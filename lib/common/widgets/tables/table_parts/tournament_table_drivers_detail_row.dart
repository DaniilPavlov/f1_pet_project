import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_standings_model.dart';
import 'package:flutter/material.dart';

/// Формирует ячейки строки таблицы пилотов.
List<Widget> tournamentTableDriversDetailRowChildren(DriverStandingsModel driverStanding, int place) {
  const textStyle = AppStyles.caption;

  return [
    Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(place.toString(), style: textStyle, textAlign: TextAlign.center),
      ),
    ),
    Center(
      child: Text(
        '${driverStanding.driver.givenName}\n${driverStanding.driver.familyName}',
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
    Center(
      child: Text(driverStanding.driver.nationality, style: textStyle, textAlign: TextAlign.center),
    ),
    Center(
      child: Text(driverStanding.points, style: textStyle, textAlign: TextAlign.center),
    ),
    Center(
      child: Text(driverStanding.wins, style: textStyle, textAlign: TextAlign.center),
    ),
    Center(
      child: Text(driverStanding.constructors[0].name, style: textStyle, textAlign: TextAlign.center),
    ),
  ];
}
