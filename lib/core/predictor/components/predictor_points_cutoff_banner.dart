import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_score_service.dart';
import 'package:flutter/material.dart';

/// Полоска после P22: ниже очки не начисляются.
class PredictorPointsCutoffBanner extends StatelessWidget {
  const PredictorPointsCutoffBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Row(
        children: [
          Expanded(child: Divider(height: 1, thickness: 1, color: colors.strokeGray)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              context.l10n.predictorPointsCutoff(PredictorScoreService.scoredPositions),
              style: AppStyles.caption.copyWith(color: colors.textGray),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: Divider(height: 1, thickness: 1, color: colors.strokeGray)),
        ],
      ),
    );
  }
}
