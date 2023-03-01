// ignore_for_file: avoid-returning-widgets

import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:flutter/material.dart';

//* Возвращает список детей ряда таблицы
List<Widget> constructorsChampionsTableDetailRowChildren(
  StandingsListsModel constructorStanding,
) {
  const textStyle = AppStyles.caption;

  return [
    Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          constructorStanding.season,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    ),
    Center(
      child: Text(
        constructorStanding.ConstructorStandings![0].Constructor.name,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        constructorStanding.ConstructorStandings![0].Constructor.nationality,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        constructorStanding.ConstructorStandings![0].points,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        constructorStanding.round,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        constructorStanding.ConstructorStandings![0].wins,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
  ];
}
