import 'package:f1_pet_project/core/profile/utils/auth_error_l10n.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('authErrorMessage', () {
    test('null returns empty', () {
      expect(authErrorMessage(l10n, null), '');
    });

    test('maps known keys', () {
      expect(authErrorMessage(l10n, 'authErrorEmptyFields'), l10n.authErrorEmptyFields);
      expect(authErrorMessage(l10n, 'authErrorEmptyEmail'), l10n.authErrorEmptyEmail);
      expect(authErrorMessage(l10n, 'authErrorInvalidEmail'), l10n.authErrorInvalidEmail);
      expect(authErrorMessage(l10n, 'authErrorUserDisabled'), l10n.authErrorUserDisabled);
      expect(authErrorMessage(l10n, 'authErrorUserNotFound'), l10n.authErrorUserNotFound);
      expect(authErrorMessage(l10n, 'authErrorWrongPassword'), l10n.authErrorWrongPassword);
      expect(authErrorMessage(l10n, 'authErrorInvalidCredential'), l10n.authErrorInvalidCredential);
      expect(authErrorMessage(l10n, 'authErrorEmailInUse'), l10n.authErrorEmailInUse);
      expect(authErrorMessage(l10n, 'authErrorWeakPassword'), l10n.authErrorWeakPassword);
      expect(authErrorMessage(l10n, 'authErrorDisposableEmail'), l10n.authErrorDisposableEmail);
      expect(authErrorMessage(l10n, 'authErrorTooManyRequests'), l10n.authErrorTooManyRequests);
      expect(authErrorMessage(l10n, 'authErrorNetwork'), l10n.authErrorNetwork);
      expect(authErrorMessage(l10n, 'authErrorGeneric'), l10n.authErrorGeneric);
    });

    test('unknown key falls back to generic', () {
      expect(authErrorMessage(l10n, 'nope'), l10n.authErrorGeneric);
    });
  });
}
