import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/material.dart';

//* Возвращает список детей ряда таблицы
List<Widget> driversChampionsTableDetailRowChildren(
  StandingsListsModel driverStanding,
) {
  const textStyle = AppStyles.caption;

  return [
    Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          driverStanding.season,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    ),
    Center(
      child: Text(
        '${driverStanding.driverStandings![0].driver.givenName}\n${driverStanding.driverStandings![0].driver.familyName}',
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        driverStanding.driverStandings![0].driver.nationality,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        driverStanding.driverStandings![0].points,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        driverStanding.round,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        driverStanding.driverStandings![0].wins,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        driverStanding.driverStandings![0].constructors[0].name,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
  ];
}
