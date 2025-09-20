import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_model.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/standings/constructors_standings_loader.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/standings/drivers_standings_loader.dart';

class HallOfFameScreenModel extends ElementaryModel {
  Future<StandingsModel> loadDriversStandings({required String year}) async {
    final rawData = await DriversStandingsLoader.loadData(year: year);

    return StandingsModel.fromJson(
      rawData.mrData as Map<String, dynamic>,
    );
  }

  Future<StandingsModel> loadConstructorsStandings({required String year}) async {
    final rawData = await ConstructorsStandingssLoader.loadData(year: year);

    return StandingsModel.fromJson(
      rawData.mrData as Map<String, dynamic>,
    );
  }
}
