import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/current_constructors_standings_loader.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/current_drivers_standings_loader.dart';
import 'package:f1_pet_project/domain/services/executor.dart';

// TODO(pavlov): обрабатывать ошибки неудобно и пока не ясно как
class HomeRepository {
  Future<List<DriverStandingsModel>?> loadCurrentDriversStandings() async {
    List<DriverStandingsModel>? result;
    await execute<StandingsModel>(
      () async {
        final rawData = await CurrentDriversStandingsLoader.loadData();
        return StandingsModel.fromJson(
          rawData.MRData as Map<String, dynamic>,
        );
      },
      // before: _currentConstructors.loading,
      onSuccess: (data) {
        result = data!.StandingsTable.StandingsLists[0].DriverStandings;
        //  _currentSeason.accept(data.StandingsTable.StandingsLists[0].season);
        // _currentRound.accept(data.StandingsTable.StandingsLists[0].round);
      },
      // onError: (value) {
      //   _screenError.accept(value);
      //   _currentDrivers.error(value);
      // },
    );
    return result;
  }

  Future<String?> loadCurrentRound() async {
    String? result;
    await execute<StandingsModel>(
      () async {
        final rawData = await CurrentConstructorsStandingsLoader.loadData();

        return StandingsModel.fromJson(
          rawData.MRData as Map<String, dynamic>,
        );
      },
      // before: _currentConstructors.loading,
      onSuccess: (data) {
        result = data!.StandingsTable.StandingsLists[0].round;
      },
      // onError: (value) {
      //   // _screenError.accept(value);
      //   // _currentDrivers.error(value);
      // },
    );
    return result;
  }

  Future<String?> loadCurrentSeason() async {
    String? result;
    await execute<StandingsModel>(
      () async {
        final rawData = await CurrentConstructorsStandingsLoader.loadData();

        return StandingsModel.fromJson(
          rawData.MRData as Map<String, dynamic>,
        );
      },
      // before: _currentConstructors.loading,
      onSuccess: (data) {
        result = data!.StandingsTable.StandingsLists[0].season;
      },
      // onError: (value) {
      //   _screenError.accept(value);
      //   _currentDrivers.error(value);
      // },
    );
    return result;
  }

  Future<List<ConstructorStandingsModel>?>
      loadCurrentConstructorsStandings() async {
    List<ConstructorStandingsModel>? result;
    await execute<StandingsModel>(
      () async {
        final rawData = await CurrentConstructorsStandingsLoader.loadData();

        return StandingsModel.fromJson(
          rawData.MRData as Map<String, dynamic>,
        );
      },
      // before: _currentConstructors.loading,
      onSuccess: (data) {
        result = data!.StandingsTable.StandingsLists[0].ConstructorStandings;
      },
      // onError: (value) {
      //   _screenError.accept(value);
      //   _currentDrivers.error(value);
      // },
    );
    return result;
  }
}
