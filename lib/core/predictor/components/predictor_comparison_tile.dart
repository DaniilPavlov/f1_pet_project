import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_comparison.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter/material.dart';

/// Строка: позиция, предикт, факт, угадал/нет.
class PredictorComparisonTile extends StatelessWidget {
  const PredictorComparisonTile({
    required this.row,
    required this.driversById,
    required this.predictedLabel,
    required this.actualLabel,
    super.key,
  });

  final PredictorComparisonRow row;
  final Map<String, DriverModel> driversById;
  final String predictedLabel;
  final String actualLabel;

  @override
  Widget build(BuildContext context) {
    final predicted = predictorDriverLabel(driversById[row.predictedDriverId], row.predictedDriverId);
    final actual = predictorDriverLabel(driversById[row.actualDriverId], row.actualDriverId);
    final tint = row.isCorrect ? const Color(0xFF1B7F4A) : AppTheme.red;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.colors.grayBG,
        borderRadius: AppTheme.defaultBorderRadius,
        border: Border(left: BorderSide(color: tint, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${row.position}',
              style: AppStyles.body.copyWith(fontFamily: 'HelveticaNeueCyr-Bold'),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$predictedLabel: $predicted',
                  style: AppStyles.body,
                ),
                const SizedBox(height: 2),
                Text(
                  '$actualLabel: $actual',
                  style: AppStyles.caption.copyWith(color: context.colors.textGray),
                ),
              ],
            ),
          ),
          Icon(
            row.isCorrect ? Icons.check_circle : Icons.cancel,
            color: tint,
            size: 20,
          ),
        ],
      ),
    );
  }
}
