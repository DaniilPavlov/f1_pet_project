import 'package:f1_pet_project/common/utils/helpers/fetch_and_parse.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:f1_pet_project/services/jolpica_error_body_fallback.dart';

/// Детали уикенда и поиск гонки (Jolpica).
class RaceWeekendRepository {
  const RaceWeekendRepository();

  Future<ScheduleModel> raceResults({required String year, required String round}) => fetchAndParse(
    load: () => ApiLoader.get('$year/$round/results'),
    parse: ScheduleModel.fromJson,
  );

  Future<ScheduleModel> sprintResults({required String year, required String round}) => fetchAndParse(
    load: () => ApiLoader.get('$year/$round/sprint'),
    parse: ScheduleModel.fromJson,
    wrap: withErrorBodyFallback,
  );

  Future<ScheduleModel> qualifyingResults({required String year, required String round}) => fetchAndParse(
    load: () => ApiLoader.get('$year/$round/qualifying'),
    parse: ScheduleModel.fromJson,
    wrap: withErrorBodyFallback,
  );

  Future<ScheduleModel> pitStops({required String year, required String round}) => fetchAndParse(
    load: () => ApiLoader.get('$year/$round/pitstops'),
    parse: ScheduleModel.fromJson,
    wrap: withErrorBodyFallback,
  );

  Future<List<RacesModel>> seasonRaces({required String year}) async {
    final response = await ApiLoader.get(year);
    final model = ScheduleModel.fromJson(Map<String, dynamic>.from(response.mrData as Map));
    return model.raceTable.races;
  }
}
