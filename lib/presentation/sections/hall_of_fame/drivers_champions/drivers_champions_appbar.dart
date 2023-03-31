import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/material.dart';

class DriversChampionsAppBar extends StatelessWidget {
  const DriversChampionsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = AppStyles.caption.copyWith(
      color: Colors.white,
    );

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Год',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.zero,
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
              'Страна',
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
              'Раунды',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.zero,
            child: Text(
              'Победы',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.zero,
            child: Text(
              'Команда',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
