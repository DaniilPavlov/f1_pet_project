import 'package:f1_pet_project/data/models/sections/results/qualifying_results_model.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/material.dart';

//* Возвращает список детей ряда таблицы
List<Widget> qualificationTableDetailRowChildren(
  QualifyingResultsModel results,
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
        results.q1,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        results.q2 ?? (int.parse(results.position) < 16 ? '-' : ''),
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        results.q3 ?? (int.parse(results.position) < 11 ? '-' : ''),
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
  ];
}
