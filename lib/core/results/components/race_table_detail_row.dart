import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Формирует ячейки строки с результатом пилота в гонке.
List<Widget> raceTableDetailRowChildren(ResultsModel results, String fastestLap, int place, AppLocalizations l10n) {
  const textStyle = AppStyles.caption;

  return [
    Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 5),
            Text(place.toString(), style: textStyle, textAlign: TextAlign.left),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${results.driver.givenName}\n${results.driver.familyName}',
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
    Center(
      child: Text(results.constructor.name, style: textStyle, textAlign: TextAlign.center),
    ),
    Center(
      child: Text(results.time?.time ?? results.status, style: textStyle, textAlign: TextAlign.center),
    ),
    Center(
      child: Text(results.points, style: textStyle, textAlign: TextAlign.center),
    ),
    Center(
      child: Text(
        results.fastestLap == null
            ? l10n.none
            : fastestLap.compareTo(results.fastestLap!.time.time) == 0
            ? l10n.fastestLapLabel(results.fastestLap!.time.time)
            : results.fastestLap!.time.time,
        style: results.fastestLap != null && fastestLap.compareTo(results.fastestLap!.time.time) == 0
            ? textStyle.copyWith(color: AppTheme.red)
            : textStyle,
        textAlign: TextAlign.center,
      ),
    ),
  ];
}
