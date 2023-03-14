// ignore_for_file: avoid_annotating_with_dynamic

import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/results/driver/driver_fetching_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/loaders/driver_loader.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/loaders/pit_stops_loader.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/loaders/qualifying_results_loader.dart';

class RaceInfoScreenModel extends ElementaryModel {
  Future<ScheduleModel> loadQualifyingResults({
    required String year,
    required String round,
  }) async {
    final rawData =
        await QualifyingResultsLoader.loadData(year: year, round: round);
    return ScheduleModel.fromJson(rawData.MRData as Map<String, dynamic>);
  }

  Future<ScheduleModel> loadPitStops({
    required String year,
    required String round,
  }) async {
    final rawData = await PitStopsLoader.loadData(year: year, round: round);
    return ScheduleModel.fromJson(rawData.MRData as Map<String, dynamic>);
  }

  Future<DriverFetchingModel> loadDriverInfo({
    required String driverId,
  }) async {
    final rawData = await DriverLoader.loadData(driverId: driverId);
    return DriverFetchingModel.fromJson(rawData.MRData as Map<String, dynamic>);
  }
}
