import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

TableRow driversChampionsPrimaryRow() {
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
            'Год',
            style: textStyle,
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            'Пилот',
            style: textStyle,
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            'Страна',
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
            'Раунды',
            style: textStyle,
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            'Победы',
            style: textStyle,
          ),
        ),
      ),
    ],
  );
}
