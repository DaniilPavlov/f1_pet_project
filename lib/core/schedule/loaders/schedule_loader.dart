import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Загрузчик расписания текущего сезона из API.
abstract class ScheduleLoader {
  /// Запрашивает данные текущего сезона.
  static Future<BaseResponseModel> loadData() => ApiLoader.get('current');
}
