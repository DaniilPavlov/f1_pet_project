import 'package:f1_pet_project/l10n/app_localizations.dart';

/// Ключи ошибок лидерборда → локализованные строки.
String predictorLeaderboardErrorMessage(AppLocalizations l10n, String? key) {
  return switch (key) {
    'predictorNicknameErrorLength' => l10n.predictorNicknameErrorLength,
    'predictorNicknameErrorChars' => l10n.predictorNicknameErrorChars,
    'predictorNicknameErrorTaken' => l10n.predictorNicknameErrorTaken,
    'predictorLeaderboardOptInRequired' => l10n.predictorLeaderboardOptInRequired,
    'predictorLeaderboardErrorGeneric' => l10n.predictorLeaderboardErrorGeneric,
    null => '',
    _ => l10n.predictorLeaderboardErrorGeneric,
  };
}
