import 'package:f1_pet_project/data/models/sections/home/current_constructors_standing/current_constractors_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/current_drivers_standings/current_drivers_standings_model.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:flutter/material.dart';
// ignore_for_file: avoid-returning-widgets

//* Возвращает список детей ряда таблицы
List<Widget> tournamentTableConstructorsDetailRowChildren(
  ConstructorStanding constructorStanding,
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
        ),
      ),
    ),
    Center(
      child: Text(
        constructorStanding.constructor.name,
        style: textStyle,
      ),
    ),
    Center(
      child: Text(
        constructorStanding.points,
        style: textStyle,
      ),
    ),
    Center(
      child: Text(
        constructorStanding.wins,
        style: textStyle,
      ),
    ),
    Center(
      child: Text(
        constructorStanding.constructor.nationality,
        style: textStyle,
      ),
    ),
  ];
}
