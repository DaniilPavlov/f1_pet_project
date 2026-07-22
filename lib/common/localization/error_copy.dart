import 'package:f1_pet_project/l10n/app_localizations.dart';

/// Локализованные тексты ошибок для слоя без [BuildContext] (`executor`).
///
/// Синхронизируется из [MaterialApp] builder при смене локали.
abstract final class ErrorCopy {
  static String noConnection = 'No connection';
  static String noConnectionSubtitle =
      'Once the connection is restored, you will be able to use the app again';
  static String tooManyRequests = 'Too many requests';
  static String tooManyRequestsSubtitle =
      'The API is rate-limiting requests. Wait a moment and try again.';
  static String requestError = 'Error sending the request';
  static String responseParseError = 'Error processing the server response';
  static String unexpectedError = 'Unexpected error';

  static void sync(AppLocalizations l10n) {
    noConnection = l10n.noConnection;
    noConnectionSubtitle = l10n.noConnectionSubtitle;
    tooManyRequests = l10n.tooManyRequests;
    tooManyRequestsSubtitle = l10n.tooManyRequestsSubtitle;
    requestError = l10n.requestError;
    responseParseError = l10n.responseParseError;
    unexpectedError = l10n.unexpectedError;
  }
}
