import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:flutter/material.dart';

/// Шапка текущего уикенда: название, lock status / countdown.
class PredictorWeekendHeader extends StatelessWidget {
  const PredictorWeekendHeader({
    required this.race,
    required this.isLocked,
    required this.missingQualifyingTime,
    required this.lockCountdown,
    required this.waitingResults,
    super.key,
  });

  final RacesModel race;
  final bool isLocked;
  final bool missingQualifyingTime;
  final CountdownParts lockCountdown;
  final bool waitingResults;

  @override
  Widget build(BuildContext context) {
    final status = _statusText(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(race.raceName, style: AppStyles.h3),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isLocked ? AppTheme.pink.withValues(alpha: 0.35) : context.colors.grayBG,
            borderRadius: AppTheme.defaultBorderRadius,
          ),
          child: Text(
            status,
            style: AppStyles.caption.copyWith(color: context.colors.black),
          ),
        ),
      ],
    );
  }

  String _statusText(BuildContext context) {
    final l10n = context.l10n;
    if (missingQualifyingTime) {
      return l10n.predictorMissingQualiTime;
    }
    if (isLocked) {
      if (waitingResults) {
        return '${l10n.predictorLocked} · ${l10n.predictorWaitingResults}';
      }
      return l10n.predictorLocked;
    }
    final countdown =
        '${lockCountdown.days.toString().padLeft(2, '0')}:'
        '${lockCountdown.hours.toString().padLeft(2, '0')}:'
        '${lockCountdown.minutes.toString().padLeft(2, '0')}:'
        '${lockCountdown.seconds.toString().padLeft(2, '0')}';
    return l10n.predictorLockIn(countdown);
  }
}
