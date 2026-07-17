import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Загрузчик зачёта пилотов с API.
abstract class DriversStandingsLoader {
  /// Получает сырые данные зачёта пилотов за сезон.
  static Future<BaseResponseModel> loadData({required String year}) => ApiLoader.get('$year/driverStandings');
}
