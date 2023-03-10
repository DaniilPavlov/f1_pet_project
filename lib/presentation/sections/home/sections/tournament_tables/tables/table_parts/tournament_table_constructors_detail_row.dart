import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:flutter/material.dart';
// ignore_for_file: avoid-returning-widgets

//* Возвращает список детей ряда таблицы
List<Widget> tournamentTableConstructorsDetailRowChildren(
  ConstructorStandingsModel constructorStanding,
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
      child: Text(
        constructorStanding.Constructor.name,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        constructorStanding.points,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        constructorStanding.wins,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        constructorStanding.Constructor.nationality,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
  ];
}
