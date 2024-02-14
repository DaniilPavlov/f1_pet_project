import 'package:f1_pet_project/data/models/sections/results/pit_stops_model.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/material.dart';

//* Возвращает список детей ряда таблицы
List<Widget> pitStopsTableDetailRowChildren(
  PitStopsModel results,
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
                results.driverId,
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
        results.lap,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        results.stop,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        results.duration,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        results.time,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
  ];
}
