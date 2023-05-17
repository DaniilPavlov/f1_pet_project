import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';

class HallOfFameData {
  final List<StandingsListsModel>? constructors;
  final List<StandingsListsModel>? drivers;

  HallOfFameData({
    required this.constructors,
    required this.drivers,
  });
}
