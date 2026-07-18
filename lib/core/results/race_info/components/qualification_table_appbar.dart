import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Закрепляемая шапка таблицы квалификации.
class QualificationTableAppBar extends StatelessWidget {
  const QualificationTableAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = AppStyles.caption.copyWith(color: Colors.white);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.qualifying,
          style: AppStyles.h2.copyWith(color: AppTheme.white),
          textAlign: TextAlign.center,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(context.l10n.driver, style: textStyle, textAlign: TextAlign.center),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Text(context.l10n.constructor, style: textStyle, textAlign: TextAlign.center),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Text('Q1', style: textStyle, textAlign: TextAlign.center),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Text('Q2', style: textStyle, textAlign: TextAlign.center),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Text('Q3', style: textStyle, textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
