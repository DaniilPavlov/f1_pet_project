import 'package:f1_pet_project/core/profile/utils/auth_form_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthFormValidators.password', () {
    test('requires length letter and digit', () {
      expect(AuthFormValidators.isPasswordStrongEnough('short1'), isFalse);
      expect(AuthFormValidators.isPasswordStrongEnough('longenough'), isFalse);
      expect(AuthFormValidators.isPasswordStrongEnough('12345678'), isFalse);
      expect(AuthFormValidators.isPasswordStrongEnough('Passw0rd'), isTrue);
    });
  });

  group('AuthFormValidators.disposable', () {
    test('blocks known temp domains', () {
      expect(AuthFormValidators.isDisposableEmail('a@mailinator.com'), isTrue);
      expect(AuthFormValidators.isDisposableEmail('a@YopMail.com'), isTrue);
      expect(AuthFormValidators.isDisposableEmail('a@sub.mailinator.com'), isTrue);
      expect(AuthFormValidators.isDisposableEmail('user@gmail.com'), isFalse);
    });

    test('email format', () {
      expect(AuthFormValidators.isEmailFormatOk('a@b.c'), isTrue);
      expect(AuthFormValidators.isEmailFormatOk('bad'), isFalse);
    });
  });
}
