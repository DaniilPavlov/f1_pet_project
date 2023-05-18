import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_model.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/champions/constructors_champions_loader.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/champions/drivers_champions_loader.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/providers/hall_of_fame/hall_of_fame_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HallOfFameRepository {
  Future<List<StandingsListsModel>?> loadDriversChampions(
    AutoDisposeFutureProviderRef<List<StandingsListsModel>?> ref,
  ) async {
    List<StandingsListsModel>? result;
    await execute<StandingsModel>(
      () async {
        final rawData = await DriversChampionsLoader.loadData();

        return StandingsModel.fromJson(
          rawData.MRData as Map<String, dynamic>,
        );
      },
      onSuccess: (data) {
        result = data!.StandingsTable.StandingsLists;
        ref.read(hallOfFameErrorProvider.notifier).update((state) => null);
      },
      onError: (value) {
        ref.read(hallOfFameErrorProvider.notifier).update((state) => value);
      },
    );
    return result;
  }

  Future<List<StandingsListsModel>?> loadConstructorsChampions(
    AutoDisposeFutureProviderRef<List<StandingsListsModel>?> ref,
  ) async {
    List<StandingsListsModel>? result;
    await execute<StandingsModel>(
      () async {
        final rawData = await ConstructorsChampionsLoader.loadData();
        return StandingsModel.fromJson(
          rawData.MRData as Map<String, dynamic>,
        );
      },
      onSuccess: (data) {
        result = data!.StandingsTable.StandingsLists;
        ref.read(hallOfFameErrorProvider.notifier).update((state) => null);
      },
      onError: (value) {
        ref.read(hallOfFameErrorProvider.notifier).update((state) => value);
      },
    );
    return result;
  }
}
