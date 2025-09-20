import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/data/models/sections/results/driver/driver_fetching_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/loaders/driver_loader.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/loaders/pit_stops_loader.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/loaders/qualifying_results_loader.dart';
import 'package:f1_pet_project/domain/services/interceptors_functions.dart';

class RaceInfoScreenModel extends ElementaryModel {
  Future<ScheduleModel> loadQualifyingResults({
    required String year,
    required String round,
  }) async {
    BaseResponseModel? rawData;
    rawData = await checkCache(
      () async => QualifyingResultsLoader.loadData(year: year, round: round),
    );

    return ScheduleModel.fromJson(rawData!.mrData as Map<String, dynamic>);
  }

  Future<ScheduleModel> loadPitStops({
    required String year,
    required String round,
  }) async {
    BaseResponseModel? rawData;

    /// Cache usage example.
    rawData = await checkCache(
      () async => PitStopsLoader.loadData(year: year, round: round),
    );

    return ScheduleModel.fromJson(rawData!.mrData as Map<String, dynamic>);
  }

  Future<DriverFetchingModel> loadDriverInfo({required String driverId}) async {
    BaseResponseModel? rawData;
    rawData = await checkCache(() async => DriverLoader.loadData(driverId: driverId));
    return DriverFetchingModel.fromJson(
      rawData!.mrData as Map<String, dynamic>,
    );
  }
}
