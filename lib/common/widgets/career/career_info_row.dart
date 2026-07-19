import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Строка «лейбл — значение» на экранах карьеры.
class CareerInfoRow extends StatelessWidget {
  const CareerInfoRow({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppStyles.body.copyWith(color: AppTheme.textGray))),
          Expanded(child: Text(value, style: AppStyles.body, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
