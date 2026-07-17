import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Загрузчик данных пит-стопов с API.
abstract class PitStopsLoader {
  /// Получает сырые данные пит-стопов за сезон и раунд.
  static Future<BaseResponseModel> loadData({required String year, required String round}) =>
      ApiLoader.get('$year/$round/pitstops');
}
