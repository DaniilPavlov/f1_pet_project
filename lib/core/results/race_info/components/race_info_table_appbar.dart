import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Закрепляемая шапка таблицы результатов гонки или спринта.
class RaceInfoTableAppBar extends StatelessWidget {
  const RaceInfoTableAppBar({this.title = 'Гонка', super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppStyles.caption.copyWith(
      color: Colors.white,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppStyles.h2.copyWith(color: AppTheme.white),
          textAlign: TextAlign.center,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'Пилот',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Text(
                  'Конструктор',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Text(
                  'Время',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Text(
                  'Очки',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
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
        ),
      ],
    );
  }
}
