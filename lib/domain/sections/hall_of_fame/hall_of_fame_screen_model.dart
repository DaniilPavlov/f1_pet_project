import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_model.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/champions/constructors_champions_loader.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/champions/drivers_champions_loader.dart';

class HallOfFameScreenModel extends ElementaryModel {
  Future<StandingsModel> loadDriversChampions() async {
    final rawData = await DriversChampionsLoader.loadData();

    return StandingsModel.fromJson(
      rawData.mrData as Map<String, dynamic>,
    );
  }

  Future<StandingsModel> loadConstructorsChampions() async {
    final rawData = await ConstructorsChampionsLoader.loadData();

    return StandingsModel.fromJson(
      rawData.mrData as Map<String, dynamic>,
    );
  }
}
