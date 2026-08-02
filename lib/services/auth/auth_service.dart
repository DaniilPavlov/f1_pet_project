import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Result Object: успех/ошибка auth без исключений наружу.
///
/// [errorMessage] — ключ l10n (`authError…`), не готовый текст.
class AuthResult {
  const AuthResult.ok() : errorMessage = null;
  const AuthResult.fail(this.errorMessage);

  /// Ключ ошибки для UI или `null` при успехе.
  final String? errorMessage;

  /// `true`, если операция завершилась без ошибки.
  bool get isSuccess => errorMessage == null;
}

/// Surface форм входа / регистрации (для Fake в unit-тестах).
abstract interface class AuthFormGateway {
  Future<AuthResult> signIn({required String email, required String password});

  Future<AuthResult> register({required String email, required String password});

  Future<AuthResult> sendPasswordResetEmail({required String email});
}

/// Facade: [FirebaseAuth] + bootstrap профиля в Firestore (`users/{uid}`).
///
/// UI и контроллеры ходят сюда, а не напрямую в Firebase Auth SDK.
class AuthService implements AuthFormGateway {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  /// Текущий Firebase-пользователь или `null`.
  User? get currentUser => _auth.currentUser;

  /// Включает обновления после [User.reload] (в отличие от [authStateChanges]).
  Stream<User?> get userChanges => _auth.userChanges();

  /// Есть ли активная сессия.
  bool get isSignedIn => currentUser != null;

  /// Подтверждён ли email у текущего пользователя.
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  /// Предиктор доступен только после входа и подтверждения email.
  bool get canUsePredictor => isSignedIn && isEmailVerified;

  /// Вход по email/password.
  @override
  Future<AuthResult> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      await ensureUserDocument();
      return const AuthResult.ok();
    } on FirebaseAuthException catch (e) {
      return AuthResult.fail(_mapError(e));
    } on Object {
      return const AuthResult.fail('authErrorGeneric');
    }
  }

  /// Регистрация + письмо подтверждения + документ `users/{uid}`.
  @override
  Future<AuthResult> register({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      await ensureUserDocument();
      await sendEmailVerification();
      return const AuthResult.ok();
    } on FirebaseAuthException catch (e) {
      return AuthResult.fail(_mapError(e));
    } on Object {
      return const AuthResult.fail('authErrorGeneric');
    }
  }

  /// Письмо со ссылкой сброса пароля (Firebase Auth).
  @override
  Future<AuthResult> sendPasswordResetEmail({required String email}) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      return const AuthResult.fail('authErrorEmptyEmail');
    }
    try {
      await _auth.sendPasswordResetEmail(email: trimmed);
      return const AuthResult.ok();
    } on FirebaseAuthException catch (e) {
      return AuthResult.fail(_mapError(e));
    } on Object {
      return const AuthResult.fail('authErrorGeneric');
    }
  }

  /// Выход из аккаунта.
  Future<void> signOut() => _auth.signOut();

  /// Если ошибка значит «сессии больше нет» — [signOut]. Иначе ничего.
  Future<void> signOutIfSessionDead(Object error) async {
    if (error is FirebaseAuthException && _isDeadSessionCode(error.code)) {
      await signOut();
      return;
    }
    if (error is FirebaseException && error.code == 'unauthenticated') {
      await signOut();
    }
  }

  static bool _isDeadSessionCode(String code) {
    return code == 'user-not-found' ||
        code == 'user-disabled' ||
        code == 'user-token-expired' ||
        code == 'invalid-user-token';
  }

  /// Отправляет письмо подтверждения (если пользователь не подтверждён).
  Future<AuthResult> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) {
      return const AuthResult.fail('authErrorGeneric');
    }
    if (user.emailVerified) {
      return const AuthResult.ok();
    }
    try {
      await user.sendEmailVerification();
      return const AuthResult.ok();
    } on FirebaseAuthException catch (e) {
      await signOutIfSessionDead(e);
      return AuthResult.fail(_mapError(e));
    } on Object {
      return const AuthResult.fail('authErrorGeneric');
    }
  }

  /// Перечитывает пользователя и обновляет ID token (нужно для Firestore `email_verified`).
  Future<bool> refreshEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) {
      return false;
    }
    try {
      await user.reload();
      final refreshed = _auth.currentUser;
      if (refreshed == null) {
        await signOut();
        return false;
      }
      await refreshed.getIdToken(true);
      if (refreshed.emailVerified) {
        await ensureUserDocument();
      }
      return refreshed.emailVerified;
    } on FirebaseAuthException catch (e) {
      await signOutIfSessionDead(e);
      return false;
    }
  }

  /// Создаёт `users/{uid}` при первом входе; иначе обновляет email.
  Future<void> ensureUserDocument() async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }
    try {
      final ref = _firestore.collection('users').doc(user.uid);
      final existing = await ref.get();
      if (existing.exists) {
        await ref.set({
          'email': user.email,
          'emailVerified': user.emailVerified,
        }, SetOptions(merge: true));
        return;
      }
      await ref.set({
        'email': user.email,
        'emailVerified': user.emailVerified,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on Object catch (e) {
      await signOutIfSessionDead(e);
      rethrow;
    }
  }

  @visibleForTesting
  static String mapErrorCode(String code) => _mapErrorCode(code);

  static String _mapError(FirebaseAuthException e) => _mapErrorCode(e.code);

  static String _mapErrorCode(String code) {
    return switch (code) {
      'invalid-email' => 'authErrorInvalidEmail',
      'user-disabled' => 'authErrorUserDisabled',
      'user-not-found' => 'authErrorUserNotFound',
      'wrong-password' => 'authErrorWrongPassword',
      'invalid-credential' => 'authErrorInvalidCredential',
      'email-already-in-use' => 'authErrorEmailInUse',
      'weak-password' => 'authErrorWeakPassword',
      'too-many-requests' => 'authErrorTooManyRequests',
      'network-request-failed' => 'authErrorNetwork',
      _ => 'authErrorGeneric',
    };
  }
}
