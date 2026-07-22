import 'package:f1_pet_project/common/utils/helpers/fetch_and_parse.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Результаты последней гонки (Jolpica).
class ResultsRepository {
  const ResultsRepository();

  Future<ScheduleModel> lastRace() => fetchAndParse(
    load: () => ApiLoader.get('current/last/results'),
    parse: ScheduleModel.fromJson,
  );
}
