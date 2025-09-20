import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/last_race_results_loader.dart';

class ResultsScreenModel extends ElementaryModel {
  Future<ScheduleModel> loadLastRaceResults() async {
    final rawData = await LastRaceResultsLoader.loadData();
    return ScheduleModel.fromJson(rawData.mrData as Map<String, dynamic>);
  }
}
