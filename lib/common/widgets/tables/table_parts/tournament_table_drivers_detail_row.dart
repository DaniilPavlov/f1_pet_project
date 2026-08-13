import 'package:f1_pet_project/common/utils/constructor_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/country_flag.dart';
import 'package:f1_pet_project/common/widgets/tables/animated_points_bar.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:flutter/material.dart';

/// Формирует ячейки строки таблицы пилотов.
///
/// [maxPoints] — максимум очков в таблице для относительной полоски.
List<Widget> tournamentTableDriversDetailRowChildren(
  DriverStandingsModel driverStanding,
  int place, {
  double maxPoints = 0,
}) {
  const textStyle = AppStyles.caption;
  final points = double.tryParse(driverStanding.points) ?? 0;
  final constructorId =
      driverStanding.constructors.isNotEmpty ? driverStanding.constructors.first.constructorId : '';

  return [
    Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(place.toString(), style: textStyle, textAlign: TextAlign.center, softWrap: false),
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
      child: CountryFlag(countryOrNationality: driverStanding.driver.nationality),
    ),
    Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(driverStanding.points, style: textStyle, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            AnimatedPointsBar(
              value: points,
              maxValue: maxPoints > 0 ? maxPoints : points,
              color: ConstructorColors.forConstructorId(constructorId),
            ),
          ],
        ),
      ),
    ),
    Center(
      child: Text(driverStanding.wins, style: textStyle, textAlign: TextAlign.center),
    ),
    Center(
      child: Text(driverStanding.constructors[0].name, style: textStyle, textAlign: TextAlign.center),
    ),
  ];
}
