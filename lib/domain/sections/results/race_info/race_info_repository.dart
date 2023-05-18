import 'package:f1_pet_project/data/models/sections/results/driver/driver_fetching_model.dart';
import 'package:f1_pet_project/data/models/sections/results/pit_stops_model.dart';
import 'package:f1_pet_project/data/models/sections/results/qualifying_results_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/loaders/driver_loader.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/loaders/pit_stops_loader.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/loaders/qualifying_results_loader.dart';
import 'package:f1_pet_project/domain/services/executor.dart';

// TODO(pavlov): обрабатывать ошибки неудобно и пока не ясно как
class RaceInfoRepository {
  Future<List<PitStopsModel>?> loadPitStops({
    required String year,
    required String round,
  }) async {
    List<PitStopsModel>? result;
    var hasError = false;
    await execute<ScheduleModel>(
      () async {
        final rawData = await PitStopsLoader.loadData(year: year, round: round);
        return ScheduleModel.fromJson(rawData.MRData as Map<String, dynamic>);
      },
      // before: _currentConstructors.loading,
      onSuccess: (data) {
        result = data!.RaceTable.Races[0].PitStops;
        //  _currentSeason.accept(data.StandingsTable.StandingsLists[0].season);
        // _currentRound.accept(data.StandingsTable.StandingsLists[0].round);
      },
      onError: (value) {
        // _screenError.accept(value);
        // _currentDrivers.error(value);
        hasError = true;
      },
    );

    if (!hasError) {
      for (var i = 0; i < result!.length; i++) {
        await execute<DriverFetchingModel>(
          () async {
            final rawData =
                await DriverLoader.loadData(driverId: result![i].driverId);
            return DriverFetchingModel.fromJson(
              rawData.MRData as Map<String, dynamic>,
            );
          },
          onSuccess: (data) {
            result![i] = result![i].copyWith(
              driverId:
                  '${data!.DriverTable.Drivers[0].givenName} ${data.DriverTable.Drivers[0].familyName}',
            );
          },
          onError: (value) {
            // _screenError.accept(value);
            // _pitStops.error(value);
          },
        );
      }
    }

    return result;
  }

  Future<List<QualifyingResultsModel>?> loadQualifyingResults({
    required String year,
    required String round,
  }) async {
    List<QualifyingResultsModel>? result;
    await execute<ScheduleModel>(
      () async {
        final rawData =
            await QualifyingResultsLoader.loadData(year: year, round: round);
        return ScheduleModel.fromJson(rawData.MRData as Map<String, dynamic>);
      },
      // before: _currentConstructors.loading,
      onSuccess: (data) {
        result = data!.RaceTable.Races[0].QualifyingResults;
      },
      // onError: (value) {
      //   // _screenError.accept(value);
      //   // _currentDrivers.error(value);
      // },
    );
    return result;
  }
}
