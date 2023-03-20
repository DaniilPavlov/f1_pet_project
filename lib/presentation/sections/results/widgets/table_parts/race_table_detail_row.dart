import 'package:f1_pet_project/data/models/sections/results/results_model.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';
// ignore_for_file: avoid-returning-widgets

//* Возвращает список детей ряда таблицы
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
                '${results.Driver.givenName}\n${results.Driver.familyName}',
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
        results.Constructor.name,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        results.Time?.time ?? results.status,
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
        results.FastestLap == null
            ? 'отсутствует'
            : fastestLap.compareTo(results.FastestLap!.Time.time) == 0
                ? '${results.FastestLap!.Time.time}\nсамый\nбыстрый'
                : results.FastestLap!.Time.time,
        style: results.FastestLap == null
            ? textStyle
            : fastestLap.compareTo(results.FastestLap!.Time.time) == 0
                ? textStyle.copyWith(color: AppTheme.red)
                : textStyle,
        textAlign: TextAlign.center,
      ),
    ),
  ];
}
