import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/results/race_info/components/race_info_table_appbar.dart';
import 'package:flutter/material.dart';

/// Закрепляемая шапка колонок таблицы квалификации.
class QualificationTableAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QualificationTableAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kRaceInfoColumnHeadersHeight);

  @override
  Widget build(BuildContext context) {
    final textStyle = AppStyles.caption.copyWith(color: AppTheme.onChrome);

    return SizedBox(
      height: kRaceInfoColumnHeadersHeight,
      child: Row(
        children: [
          Expanded(child: Text(context.l10n.driver, style: textStyle, textAlign: TextAlign.center, maxLines: 1)),
          Expanded(child: Text(context.l10n.constructor, style: textStyle, textAlign: TextAlign.center, maxLines: 1)),
          Expanded(child: Text('Q1', style: textStyle, textAlign: TextAlign.center, maxLines: 1)),
          Expanded(child: Text('Q2', style: textStyle, textAlign: TextAlign.center, maxLines: 1)),
          Expanded(child: Text('Q3', style: textStyle, textAlign: TextAlign.center, maxLines: 1)),
        ],
      ),
    );
  }
}
