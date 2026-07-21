import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Строка «лейбл — значение» на экранах карьеры.
class CareerInfoRow extends StatelessWidget {
  const CareerInfoRow({
    required this.label,
    this.value = '',
    this.valueLeading,
    this.valueWidget,
    super.key,
  });

  final String label;
  final String value;
  final Widget? valueLeading;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppStyles.body.copyWith(color: AppTheme.textGray))),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (valueLeading != null) ...[
                  valueLeading!,
                  if (valueWidget != null || value.isNotEmpty) const SizedBox(width: 8),
                ],
                if (valueWidget != null)
                  valueWidget!
                else if (value.isNotEmpty)
                  Flexible(child: Text(value, style: AppStyles.body, textAlign: TextAlign.right)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
