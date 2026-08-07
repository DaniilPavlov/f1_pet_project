import 'package:f1_pet_project/core/profile/utils/auth_form_validators.dart';
import 'package:f1_pet_project/services/auth/auth_service.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние форм входа / регистрации.
@immutable
class AuthState {
  const AuthState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.errorKey,
  });

  /// Email из поля ввода.
  final String email;

  /// Пароль из поля ввода.
  final String password;

  /// Идёт сетевой запрос auth.
  final bool isLoading;

  /// Ключ l10n ошибки или `null`.
  final String? errorKey;

  AuthState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? errorKey,
    bool clearErrorKey = false,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorKey: clearErrorKey ? null : (errorKey ?? this.errorKey),
    );
  }
}

/// Поля формы + вызовы [AuthFormGateway]; ошибки как l10n-ключи.
class AuthController extends Notifier<AuthState> {
  AuthController({@visibleForTesting AuthFormGateway? authServiceForTest})
    : _authServiceForTest = authServiceForTest;

  final AuthFormGateway? _authServiceForTest;

  AuthFormGateway get _authService => _authServiceForTest ?? ref.read(authServiceProvider);

  @override
  AuthState build() => const AuthState();

  /// Обновляет email и сбрасывает ошибку.
  void setEmail(String value) {
    state = state.copyWith(email: value, clearErrorKey: true);
  }

  /// Обновляет пароль и сбрасывает ошибку.
  void setPassword(String value) {
    state = state.copyWith(password: value, clearErrorKey: true);
  }

  /// Вход; `true` при успехе.
  Future<bool> signIn() async {
    if (!_validateSignIn()) {
      return false;
    }
    state = state.copyWith(isLoading: true, clearErrorKey: true);
    try {
      final result = await _authService.signIn(email: state.email, password: state.password);
      if (!result.isSuccess) {
        state = state.copyWith(errorKey: result.errorMessage);
        return false;
      }
      return true;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Регистрация; `true` при успехе.
  Future<bool> register() async {
    if (!_validateRegister()) {
      return false;
    }
    state = state.copyWith(isLoading: true, clearErrorKey: true);
    try {
      final result = await _authService.register(email: state.email, password: state.password);
      if (!result.isSuccess) {
        state = state.copyWith(errorKey: result.errorMessage);
        return false;
      }
      return true;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Письмо сброса пароля на email (пароль не нужен).
  Future<bool> sendPasswordReset() async {
    if (state.email.trim().isEmpty) {
      state = state.copyWith(errorKey: 'authErrorEmptyEmail');
      return false;
    }
    if (!AuthFormValidators.isEmailFormatOk(state.email)) {
      state = state.copyWith(errorKey: 'authErrorInvalidEmail');
      return false;
    }
    state = state.copyWith(isLoading: true, clearErrorKey: true);
    try {
      final result = await _authService.sendPasswordResetEmail(email: state.email);
      if (!result.isSuccess) {
        state = state.copyWith(errorKey: result.errorMessage);
        return false;
      }
      return true;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  bool _validateSignIn() {
    if (state.email.trim().isEmpty || state.password.isEmpty) {
      state = state.copyWith(errorKey: 'authErrorEmptyFields');
      return false;
    }
    if (!AuthFormValidators.isEmailFormatOk(state.email)) {
      state = state.copyWith(errorKey: 'authErrorInvalidEmail');
      return false;
    }
    return true;
  }

  bool _validateRegister() {
    if (state.email.trim().isEmpty || state.password.isEmpty) {
      state = state.copyWith(errorKey: 'authErrorEmptyFields');
      return false;
    }
    if (!AuthFormValidators.isEmailFormatOk(state.email)) {
      state = state.copyWith(errorKey: 'authErrorInvalidEmail');
      return false;
    }
    if (AuthFormValidators.isDisposableEmail(state.email)) {
      state = state.copyWith(errorKey: 'authErrorDisposableEmail');
      return false;
    }
    if (!AuthFormValidators.isPasswordStrongEnough(state.password)) {
      state = state.copyWith(errorKey: 'authErrorWeakPassword');
      return false;
    }
    return true;
  }
}

final authControllerProvider = NotifierProvider.autoDispose<AuthController, AuthState>(AuthController.new);
