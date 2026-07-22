import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/country_flag.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
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
      child: CountryFlag(countryOrNationality: constructorStanding.constructor.nationality),
    ),
    Center(
      child: Text(constructorStanding.points, style: textStyle, textAlign: TextAlign.center),
    ),
    Center(
      child: Text(constructorStanding.wins, style: textStyle, textAlign: TextAlign.center),
    ),
  ];
}
