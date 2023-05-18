import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/current_constructors_standings_loader.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/current_drivers_standings_loader.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/providers/home/home_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeRepository {
  Future<List<DriverStandingsModel>?> loadCurrentDriversStandings(
    AutoDisposeFutureProviderRef<List<DriverStandingsModel>?> ref,
  ) async {
    List<DriverStandingsModel>? result;
    await execute<StandingsModel>(
      () async {
        final rawData = await CurrentDriversStandingsLoader.loadData();
        return StandingsModel.fromJson(
          rawData.MRData as Map<String, dynamic>,
        );
      },
      onSuccess: (data) {
        result = data!.StandingsTable.StandingsLists[0].DriverStandings;
        ref
            .read(currentRoundProvider.notifier)
            .update((state) => data.StandingsTable.StandingsLists[0].round);
        ref
            .read(currentSeasonProvider.notifier)
            .update((state) => data.StandingsTable.StandingsLists[0].season);
        ref.read(homeErrorProvider.notifier).update((state) => null);
      },
      onError: (value) {
        ref.read(homeErrorProvider.notifier).update((state) => value);
      },
    );
    return result;
  }

  Future<List<ConstructorStandingsModel>?> loadCurrentConstructorsStandings(
    AutoDisposeFutureProviderRef<List<ConstructorStandingsModel>?> ref,
  ) async {
    List<ConstructorStandingsModel>? result;
    await execute<StandingsModel>(
      () async {
        final rawData = await CurrentConstructorsStandingsLoader.loadData();

        return StandingsModel.fromJson(
          rawData.MRData as Map<String, dynamic>,
        );
      },
      onSuccess: (data) {
        result = data!.StandingsTable.StandingsLists[0].ConstructorStandings;
        ref.read(homeErrorProvider.notifier).update((state) => null);
      },
      onError: (value) {
        ref.read(homeErrorProvider.notifier).update((state) => value);
      },
    );
    return result;
  }
}
