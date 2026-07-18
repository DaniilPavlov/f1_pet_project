import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Формирует заголовок таблицы зачёта конструкторов.
TableRow constructorsPrimaryRow(AppLocalizations l10n) {
  final textStyle = AppStyles.caption.copyWith(color: Colors.white);

  return TableRow(
    decoration: const BoxDecoration(
      color: AppTheme.red,
      border: Border(bottom: BorderSide(color: AppTheme.strokeGray)),
    ),
    children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text('', style: textStyle),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(l10n.constructor, style: textStyle),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(l10n.country, style: textStyle),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(l10n.points, style: textStyle),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(l10n.wins, style: textStyle),
        ),
      ),
    ],
  );
}
