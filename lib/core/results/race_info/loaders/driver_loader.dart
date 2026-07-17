import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Загрузчик информации о пилоте по идентификатору.
abstract class DriverLoader {
  /// Получает сырые данные пилота с API.
  static Future<BaseResponseModel> loadData({required String driverId}) => ApiLoader.get('drivers/$driverId');
}
