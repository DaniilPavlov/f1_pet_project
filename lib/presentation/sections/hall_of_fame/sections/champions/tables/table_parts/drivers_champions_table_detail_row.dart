// ignore_for_file: avoid-returning-widgets
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
        '${driverStanding.DriverStandings![0].Driver.givenName}\n${driverStanding.DriverStandings![0].Driver.familyName}',
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        driverStanding.DriverStandings![0].Driver.nationality,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        driverStanding.DriverStandings![0].points,
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
        driverStanding.DriverStandings![0].wins,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(
        driverStanding.DriverStandings![0].Constructors[0].name,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
  ];
}
