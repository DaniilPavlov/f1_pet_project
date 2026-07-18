import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_standings_model.dart';
import 'package:flutter/material.dart';

/// Формирует ячейки строки таблицы конструкторов.
List<Widget> tournamentTableConstructorsDetailRowChildren(ConstructorStandingsModel constructorStanding, int place) {
  const textStyle = AppStyles.caption;

  return [
    Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(place.toString(), style: textStyle, textAlign: TextAlign.center),
      ),
    ),
    Center(
      child: Text(constructorStanding.constructor.name, style: textStyle, textAlign: TextAlign.center),
    ),
    Center(
      child: Text(constructorStanding.constructor.nationality, style: textStyle, textAlign: TextAlign.center),
    ),
    Center(
      child: Text(constructorStanding.points, style: textStyle, textAlign: TextAlign.center),
    ),
    Center(
      child: Text(constructorStanding.wins, style: textStyle, textAlign: TextAlign.center),
    ),
  ];
}
