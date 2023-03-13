import 'package:f1_pet_project/data/models/sections/results/results_model.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:flutter/material.dart';
// ignore_for_file: avoid-returning-widgets

//* Возвращает список детей ряда таблицы
List<Widget> raceTableDetailRowChildren(
  ResultsModel results,
  int place,
) {
  const textStyle = AppStyles.caption;

  return [
    Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          place.toString(),
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    ),
    Center(
      // child: Text(
      //   results.Driver.code!,
      //   style: textStyle,
      //   textAlign: TextAlign.center,
      // ),
      child: Text(
        '${results.Driver.givenName}\n${results.Driver.familyName}',
        style: textStyle,
        textAlign: TextAlign.center,
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
  ];
}
