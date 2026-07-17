import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Загрузчик результатов гонки с API.
abstract class RaceResultsLoader {
  /// Получает сырые данные результатов за сезон и раунд.
  static Future<BaseResponseModel> loadData({required String year, required String round}) =>
      ApiLoader.get('$year/$round/results');
}
