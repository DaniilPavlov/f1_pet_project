import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/current_constructors_standings_loader.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/current_drivers_standings_loader.dart';

class HomeScreenModel extends ElementaryModel {
  Future<StandingsModel> loadCurrentDriversStandings() async {
    final rawData = await CurrentDriversStandingsLoader.loadData();

    return StandingsModel.fromJson(
      rawData.mrData as Map<String, dynamic>,
    );
  }

  Future<StandingsModel> loadCurrentConstructorsStandings() async {
    final rawData = await CurrentConstructorsStandingsLoader.loadData();

    return StandingsModel.fromJson(
      rawData.mrData as Map<String, dynamic>,
    );
  }
}
