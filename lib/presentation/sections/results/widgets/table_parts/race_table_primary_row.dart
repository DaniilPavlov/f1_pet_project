import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

TableRow raceTablePrimaryRow() {
  final textStyle = AppStyles.caption.copyWith(
    color: Colors.white,
  );

  return TableRow(
    decoration: const BoxDecoration(
      color: AppTheme.red,
      border: Border(
        bottom: BorderSide(
          color: AppTheme.strokeGray,
        ),
      ),
    ),
    children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Пилот',
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            'Команда',
            style: textStyle,
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            'Время',
            style: textStyle,
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            'Очки',
            style: textStyle,
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            'Лучший\nкруг',
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}
