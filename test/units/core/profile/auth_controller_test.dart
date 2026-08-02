import 'package:f1_pet_project/core/profile/controllers/auth_controller/auth_controller.dart';
import 'package:f1_pet_project/services/auth/auth_service.dart';
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

  group('AuthController', () {
    late _FakeAuthGateway gateway;
    late AuthController controller;

    setUp(() {
      gateway = _FakeAuthGateway();
      controller = AuthController(authService: gateway);
    });

    test('setEmail / setPassword clear errorKey', () {
      controller
        ..errorKey = 'authErrorGeneric'
        ..setEmail('a@b.co');
      expect(controller.email, 'a@b.co');
      expect(controller.errorKey, isNull);
      controller
        ..errorKey = 'authErrorGeneric'
        ..setPassword('Passw0rd');
      expect(controller.password, 'Passw0rd');
      expect(controller.errorKey, isNull);
    });

    test('signIn rejects empty fields', () async {
      expect(await controller.signIn(), isFalse);
      expect(controller.errorKey, 'authErrorEmptyFields');
      expect(gateway.signInCalls, 0);
      expect(controller.isLoading, isFalse);
    });

    test('signIn rejects invalid email', () async {
      controller
        ..setEmail('not-an-email')
        ..setPassword('Passw0rd');
      expect(await controller.signIn(), isFalse);
      expect(controller.errorKey, 'authErrorInvalidEmail');
      expect(gateway.signInCalls, 0);
    });

    test('signIn success', () async {
      controller
        ..setEmail('user@gmail.com')
        ..setPassword('Passw0rd');
      expect(await controller.signIn(), isTrue);
      expect(gateway.signInCalls, 1);
      expect(gateway.lastEmail, 'user@gmail.com');
      expect(controller.errorKey, isNull);
      expect(controller.isLoading, isFalse);
    });

    test('signIn maps service failure', () async {
      gateway.signInResult = const AuthResult.fail('authErrorWrongPassword');
      controller
        ..setEmail('user@gmail.com')
        ..setPassword('Passw0rd');
      expect(await controller.signIn(), isFalse);
      expect(controller.errorKey, 'authErrorWrongPassword');
      expect(controller.isLoading, isFalse);
    });

    test('register rejects disposable email', () async {
      controller
        ..setEmail('a@mailinator.com')
        ..setPassword('Passw0rd');
      expect(await controller.register(), isFalse);
      expect(controller.errorKey, 'authErrorDisposableEmail');
      expect(gateway.registerCalls, 0);
    });

    test('register rejects weak password', () async {
      controller
        ..setEmail('user@gmail.com')
        ..setPassword('password');
      expect(await controller.register(), isFalse);
      expect(controller.errorKey, 'authErrorWeakPassword');
      expect(gateway.registerCalls, 0);
    });

    test('register success', () async {
      controller
        ..setEmail('user@gmail.com')
        ..setPassword('Passw0rd1');
      expect(await controller.register(), isTrue);
      expect(gateway.registerCalls, 1);
      expect(controller.isLoading, isFalse);
    });

    test('register maps service failure', () async {
      gateway.registerResult = const AuthResult.fail('authErrorEmailInUse');
      controller
        ..setEmail('user@gmail.com')
        ..setPassword('Passw0rd1');
      expect(await controller.register(), isFalse);
      expect(controller.errorKey, 'authErrorEmailInUse');
    });

    test('sendPasswordReset validates email', () async {
      expect(await controller.sendPasswordReset(), isFalse);
      expect(controller.errorKey, 'authErrorEmptyEmail');

      controller.setEmail('bad');
      expect(await controller.sendPasswordReset(), isFalse);
      expect(controller.errorKey, 'authErrorInvalidEmail');
      expect(gateway.resetCalls, 0);
    });

    test('sendPasswordReset success and failure', () async {
      controller.setEmail('user@gmail.com');
      expect(await controller.sendPasswordReset(), isTrue);
      expect(gateway.resetCalls, 1);

      gateway.resetResult = const AuthResult.fail('authErrorTooManyRequests');
      expect(await controller.sendPasswordReset(), isFalse);
      expect(controller.errorKey, 'authErrorTooManyRequests');
      expect(controller.isLoading, isFalse);
    });
  });
}
