// ignore_for_file: avoid_annotating_with_dynamic

import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/pit_stops_loader.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/qualifying_results_loader.dart';

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
    final rawData =
        await PitStopsLoader.loadData(year: year, round: round);
    return ScheduleModel.fromJson(rawData.MRData as Map<String, dynamic>);
  }
}
