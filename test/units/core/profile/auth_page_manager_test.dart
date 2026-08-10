import 'package:f1_pet_project/core/profile/managers/auth_page_manager.dart';
import 'package:f1_pet_project/core/profile/providers.dart';
import 'package:f1_pet_project/core/profile/state/state_models/auth_page_view_model.dart';
import 'package:f1_pet_project/services/auth/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthGateway implements AuthFormGateway {
  AuthResult signInResult = const AuthResult.ok();
  AuthResult registerResult = const AuthResult.ok();
  AuthResult resetResult = const AuthResult.ok();

  int signInCalls = 0;
  int registerCalls = 0;
  int resetCalls = 0;
  String? lastEmail;
  String? lastPassword;

  @override
  Future<AuthResult> signIn({required String email, required String password}) async {
    signInCalls++;
    lastEmail = email;
    lastPassword = password;
    return signInResult;
  }

  @override
  Future<AuthResult> register({required String email, required String password}) async {
    registerCalls++;
    lastEmail = email;
    lastPassword = password;
    return registerResult;
  }

  @override
  Future<AuthResult> sendPasswordResetEmail({required String email}) async {
    resetCalls++;
    lastEmail = email;
    return resetResult;
  }
}

void main() {
  group('AuthResult', () {
    test('ok is success', () {
      expect(const AuthResult.ok().isSuccess, isTrue);
      expect(const AuthResult.ok().errorMessage, isNull);
    });

    test('fail carries key', () {
      const result = AuthResult.fail('authErrorNetwork');
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, 'authErrorNetwork');
    });
  });

  group('AuthPageManager', () {
    late _FakeAuthGateway gateway;
    late ProviderContainer container;
    late AuthPageManager manager;

    AuthPageViewModel readState() => container.read(authPageStateHolderProvider);

    setUp(() {
      gateway = _FakeAuthGateway();
      container = ProviderContainer(
        overrides: [
          authPageManagerProvider.overrideWith((ref) {
            return AuthPageManager(
              holder: ref.watch(authPageStateHolderProvider.notifier),
              authServiceForTest: gateway,
            );
          }),
        ],
      );
      manager = container.read(authPageManagerProvider);
    });

    tearDown(() => container.dispose());

    test('setEmail / setPassword clear errorKey', () async {
      expect(await manager.signIn(), isFalse);
      expect(readState().errorKey, 'authErrorEmptyFields');

      manager.setEmail('a@b.co');
      expect(readState().email, 'a@b.co');
      expect(readState().errorKey, isNull);

      expect(await manager.signIn(), isFalse);
      expect(readState().errorKey, 'authErrorEmptyFields');

      manager.setPassword('Passw0rd');
      expect(readState().password, 'Passw0rd');
      expect(readState().errorKey, isNull);
    });

    test('signIn rejects empty fields', () async {
      expect(await manager.signIn(), isFalse);
      expect(readState().errorKey, 'authErrorEmptyFields');
      expect(gateway.signInCalls, 0);
      expect(readState().isLoading, isFalse);
    });

    test('signIn rejects invalid email', () async {
      manager
        ..setEmail('not-an-email')
        ..setPassword('Passw0rd');
      expect(await manager.signIn(), isFalse);
      expect(readState().errorKey, 'authErrorInvalidEmail');
      expect(gateway.signInCalls, 0);
    });

    test('signIn success', () async {
      manager
        ..setEmail('user@gmail.com')
        ..setPassword('Passw0rd');
      expect(await manager.signIn(), isTrue);
      expect(gateway.signInCalls, 1);
      expect(gateway.lastEmail, 'user@gmail.com');
      expect(readState().errorKey, isNull);
      expect(readState().isLoading, isFalse);
    });

    test('signIn maps service failure', () async {
      gateway.signInResult = const AuthResult.fail('authErrorWrongPassword');
      manager
        ..setEmail('user@gmail.com')
        ..setPassword('Passw0rd');
      expect(await manager.signIn(), isFalse);
      expect(readState().errorKey, 'authErrorWrongPassword');
      expect(readState().isLoading, isFalse);
    });

    test('register rejects disposable email', () async {
      manager
        ..setEmail('a@mailinator.com')
        ..setPassword('Passw0rd');
      expect(await manager.register(), isFalse);
      expect(readState().errorKey, 'authErrorDisposableEmail');
      expect(gateway.registerCalls, 0);
    });

    test('register rejects weak password', () async {
      manager
        ..setEmail('user@gmail.com')
        ..setPassword('password');
      expect(await manager.register(), isFalse);
      expect(readState().errorKey, 'authErrorWeakPassword');
      expect(gateway.registerCalls, 0);
    });

    test('register success', () async {
      manager
        ..setEmail('user@gmail.com')
        ..setPassword('Passw0rd1');
      expect(await manager.register(), isTrue);
      expect(gateway.registerCalls, 1);
      expect(readState().isLoading, isFalse);
    });

    test('register maps service failure', () async {
      gateway.registerResult = const AuthResult.fail('authErrorEmailInUse');
      manager
        ..setEmail('user@gmail.com')
        ..setPassword('Passw0rd1');
      expect(await manager.register(), isFalse);
      expect(readState().errorKey, 'authErrorEmailInUse');
    });

    test('sendPasswordReset validates email', () async {
      expect(await manager.sendPasswordReset(), isFalse);
      expect(readState().errorKey, 'authErrorEmptyEmail');

      manager.setEmail('bad');
      expect(await manager.sendPasswordReset(), isFalse);
      expect(readState().errorKey, 'authErrorInvalidEmail');
      expect(gateway.resetCalls, 0);
    });

    test('sendPasswordReset success and failure', () async {
      manager.setEmail('user@gmail.com');
      expect(await manager.sendPasswordReset(), isTrue);
      expect(gateway.resetCalls, 1);

      gateway.resetResult = const AuthResult.fail('authErrorTooManyRequests');
      expect(await manager.sendPasswordReset(), isFalse);
      expect(readState().errorKey, 'authErrorTooManyRequests');
      expect(readState().isLoading, isFalse);
    });
  });
}
