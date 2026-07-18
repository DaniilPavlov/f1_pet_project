import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
