import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:flutter/material.dart';

/// Карточка уикенда в истории сезона.
class PredictorHistoryTile extends StatelessWidget {
  const PredictorHistoryTile({
    required this.weekend,
    this.onTap,
    super.key,
  });

  final PredictorWeekendPrediction weekend;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final quali = weekend.qualiPoints?.toString() ?? l10n.predictorPendingPoints;
    final race = weekend.racePoints?.toString() ?? l10n.predictorPendingPoints;

    return Semantics(
      button: onTap != null,
      label: context.l10n.predictorHistorySemantics(
        weekend.raceName,
        quali,
        race,
        weekend.totalPoints,
      ),
      child: ExcludeSemantics(
        child: Material(
          color: context.colors.grayBG,
          borderRadius: AppTheme.defaultBorderRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppTheme.defaultBorderRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weekend.raceName,
                          style: AppStyles.body.copyWith(fontFamily: 'HelveticaNeueCyr-Bold'),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.predictorWeekendPoints(quali, race, weekend.totalPoints),
                          style: AppStyles.caption.copyWith(color: context.colors.textGray),
                        ),
                      ],
                    ),
                  ),
                  if (onTap != null) Icon(Icons.chevron_right, color: context.colors.textGray),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
