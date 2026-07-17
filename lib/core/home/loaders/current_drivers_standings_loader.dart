import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Загрузчик турнирной таблицы пилотов из API.
abstract class CurrentDriversStandingsLoader {
  /// Запрашивает актуальные standings пилотов.
  static Future<BaseResponseModel> loadData() => ApiLoader.get('current/driverStandings');
}
