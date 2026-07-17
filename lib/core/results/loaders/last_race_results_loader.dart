import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Загрузчик результатов последней гонки с API.
abstract class LastRaceResultsLoader {
  /// Получает сырые данные последней гонки.
  static Future<BaseResponseModel> loadData() => ApiLoader.get('current/last/results');
}
