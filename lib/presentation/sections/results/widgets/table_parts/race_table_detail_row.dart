import 'package:f1_pet_project/data/models/sections/results/results_model.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

///* Возвращает список детей ряда таблицы
List<Widget> raceTableDetailRowChildren(
  ResultsModel results,
  String fastestLap,
  int place,
) {
  const textStyle = AppStyles.caption;

  return [
    Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 5),
            Text(
              place.toString(),
              style: textStyle,
              textAlign: TextAlign.left,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${results.driver.givenName}\n${results.driver.familyName}',
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
    Center(
      child: Text(
        results.constructor.name,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        results.time?.time ?? results.status,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        results.points,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        results.fastestLap == null
            ? 'нет'
            : fastestLap.compareTo(results.fastestLap!.time.time) == 0
                ? '${results.fastestLap!.time.time}\nсамый\nбыстрый'
                : results.fastestLap!.time.time,
        style: results.fastestLap != null &&
                fastestLap.compareTo(results.fastestLap!.time.time) == 0
            ? textStyle.copyWith(color: AppTheme.red)
            : textStyle,
        textAlign: TextAlign.center,
      ),
    ),
  ];
}
