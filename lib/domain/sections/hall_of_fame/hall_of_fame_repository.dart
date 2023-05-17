import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_model.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/champions/constructors_champions_loader.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/champions/drivers_champions_loader.dart';
import 'package:f1_pet_project/domain/services/executor.dart';

// TODO(pavlov): обрабатывать ошибки неудобно и пока не ясно как
class HallOfFameRepository {
  Future<List<StandingsListsModel>?> loadDriversChampions() async {
    List<StandingsListsModel>? result;
    await execute<StandingsModel>(
      () async {
        final rawData = await DriversChampionsLoader.loadData();

        return StandingsModel.fromJson(
          rawData.MRData as Map<String, dynamic>,
        );
      },
      // before: _constructorsChampions.loading,
      onSuccess: (data) {
        result = data!.StandingsTable.StandingsLists;
      },
      // onError: (value) {
      //   _screenError.accept(value);
      //   _constructorsChampions.error(value);
      // },
    );
    return result;
  }

  Future<List<StandingsListsModel>?> loadConstructorsChampions() async {
    List<StandingsListsModel>? result;
    await execute<StandingsModel>(
      () async {
        final rawData = await ConstructorsChampionsLoader.loadData();

        return StandingsModel.fromJson(
          rawData.MRData as Map<String, dynamic>,
        );
      },
      // before: _constructorsChampions.loading,
      onSuccess: (data) {
        result = data!.StandingsTable.StandingsLists;
      },
      // onError: (value) {
      //   _screenError.accept(value);
      //   _constructorsChampions.error(value);
      // },
    );
    return result;
  }
}
