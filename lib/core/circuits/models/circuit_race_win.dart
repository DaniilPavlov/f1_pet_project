import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';

/// Победа на трассе (из `circuits/{id}/results/1`).
class CircuitRaceWin {
  const CircuitRaceWin({
    required this.season,
    required this.round,
    required this.raceName,
    required this.driver,
    required this.constructor,
  });

  final String season;
  final String round;
  final String raceName;
  final DriverModel driver;
  final ConstructorModel constructor;

  String get driverFullName => '${driver.givenName} ${driver.familyName}';
}
