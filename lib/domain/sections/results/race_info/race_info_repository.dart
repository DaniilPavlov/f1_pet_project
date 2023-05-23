import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/data/models/sections/results/driver/driver_fetching_model.dart';
import 'package:f1_pet_project/data/models/sections/results/pit_stops_model.dart';
import 'package:f1_pet_project/data/models/sections/results/qualifying_results_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/loaders/driver_loader.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/loaders/pit_stops_loader.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/loaders/qualifying_results_loader.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/domain/services/interceptors_functions.dart';
import 'package:f1_pet_project/providers/results/race_info/race_info_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RaceInfoRepository {
  Future<List<PitStopsModel>?> loadPitStops({
    required String year,
    required String round,
    required AutoDisposeFutureProviderRef<List<PitStopsModel>?> ref,
  }) async {
    List<PitStopsModel>? result;
    var hasError = false;
    await execute<ScheduleModel>(
      () async {
        BaseResponseModel? rawData;
        // TODO(info): пример использования кэша
        rawData = await checkCache(
          () async => PitStopsLoader.loadData(year: year, round: round),
        );

        return ScheduleModel.fromJson(rawData!.MRData as Map<String, dynamic>);
      },
      onSuccess: (data) {
        result = data!.RaceTable.Races[0].PitStops;
      },
      onError: (value) {
        ref.read(raceInfoErrorProvider.notifier).update((state) => value);
        hasError = true;
      },
    );

    if (!hasError) {
      for (var i = 0; i < result!.length; i++) {
        await execute<DriverFetchingModel>(
          () async {
            BaseResponseModel? rawData;
            rawData = await checkCache(
              () async => DriverLoader.loadData(driverId: result![i].driverId),
            );

            return DriverFetchingModel.fromJson(
              rawData!.MRData as Map<String, dynamic>,
            );
          },
          onSuccess: (data) {
            result![i] = result![i].copyWith(
              driverId:
                  '${data!.DriverTable.Drivers[0].givenName} ${data.DriverTable.Drivers[0].familyName}',
            );
            ref.read(raceInfoErrorProvider.notifier).update((state) => null);
          },
          onError: (value) {
            ref.read(raceInfoErrorProvider.notifier).update((state) => value);
          },
        );
      }
    }

    return result;
  }

  Future<List<QualifyingResultsModel>?> loadQualifyingResults({
    required String year,
    required String round,
    required AutoDisposeFutureProviderRef<List<QualifyingResultsModel>?> ref,
  }) async {
    List<QualifyingResultsModel>? result;
    await execute<ScheduleModel>(
      () async {
        BaseResponseModel? rawData;
        rawData = await checkCache(
          () async =>
              QualifyingResultsLoader.loadData(year: year, round: round),
        );

        return ScheduleModel.fromJson(rawData!.MRData as Map<String, dynamic>);
      },
      onSuccess: (data) {
        result = data!.RaceTable.Races[0].QualifyingResults;
        ref.read(raceInfoErrorProvider.notifier).update((state) => null);
      },
      onError: (value) {
        ref.read(raceInfoErrorProvider.notifier).update((state) => value);
      },
    );
    return result;
  }
}
