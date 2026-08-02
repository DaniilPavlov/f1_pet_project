import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Выбор позиции P1…Pn для быстрого переноса пилота.
Future<int?> showPredictorPositionPicker({
  required BuildContext context,
  required int itemCount,
  required int currentIndex,
  required String driverLabel,
}) {
  return showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      final maxHeight = MediaQuery.sizeOf(context).height * 0.55;
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              StaticData.defaultHorizontalPadding,
              0,
              StaticData.defaultHorizontalPadding,
              16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.predictorMoveToTitle(driverLabel),
                  style: AppStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.predictorMoveToHint,
                  style: AppStyles.caption.copyWith(color: context.colors.textGray),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var i = 0; i < itemCount; i++)
                      ChoiceChip(
                        label: Text('P${i + 1}'),
                        selected: i == currentIndex,
                        selectedColor: AppTheme.red,
                        labelStyle: AppStyles.caption.copyWith(
                          color: i == currentIndex ? AppTheme.onChrome : context.colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) => Navigator.of(context).pop(i),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
