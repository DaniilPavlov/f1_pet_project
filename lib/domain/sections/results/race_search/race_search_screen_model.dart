import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_search/race_results_loader.dart';

class RaceSearchScreenModel extends ElementaryModel {
  Future<ScheduleModel> loadRaceResults({
    required String year,
    required String round,
  }) async {
    final rawData = await RaceResultsLoader.loadData(year: year, round: round);

    return ScheduleModel.fromJson(rawData.mrData as Map<String, dynamic>);
  }
}
