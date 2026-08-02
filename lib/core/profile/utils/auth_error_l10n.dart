import 'package:f1_pet_project/l10n/app_localizations.dart';

/// Adapter: ключи ошибок [AuthService] → локализованные строки UI.
String authErrorMessage(AppLocalizations l10n, String? key) {
  return switch (key) {
    'authErrorEmptyFields' => l10n.authErrorEmptyFields,
    'authErrorEmptyEmail' => l10n.authErrorEmptyEmail,
    'authErrorInvalidEmail' => l10n.authErrorInvalidEmail,
    'authErrorUserDisabled' => l10n.authErrorUserDisabled,
    'authErrorUserNotFound' => l10n.authErrorUserNotFound,
    'authErrorWrongPassword' => l10n.authErrorWrongPassword,
    'authErrorInvalidCredential' => l10n.authErrorInvalidCredential,
    'authErrorEmailInUse' => l10n.authErrorEmailInUse,
    'authErrorWeakPassword' => l10n.authErrorWeakPassword,
    'authErrorDisposableEmail' => l10n.authErrorDisposableEmail,
    'authErrorTooManyRequests' => l10n.authErrorTooManyRequests,
    'authErrorNetwork' => l10n.authErrorNetwork,
    'authErrorGeneric' => l10n.authErrorGeneric,
    null => '',
    _ => l10n.authErrorGeneric,
  };
}
