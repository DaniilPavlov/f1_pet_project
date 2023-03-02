import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:flutter/material.dart';

class LastRaceAppBar extends StatelessWidget {
  const LastRaceAppBar({super.key});

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
              'Позиция',
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
              'Команда',
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
      ],
    );
  }
}
