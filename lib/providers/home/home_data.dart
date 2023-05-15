import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';

class HomeData {
  final List<ConstructorStandingsModel>? constructors;
  final List<DriverStandingsModel>? drivers;
  final String? season;
  final String? round;

  HomeData({
    required this.constructors,
    required this.drivers,
    required this.season,
    required this.round,
  });
}
