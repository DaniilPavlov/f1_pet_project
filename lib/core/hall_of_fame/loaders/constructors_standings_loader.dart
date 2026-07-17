import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Загрузчик зачёта конструкторов с API.
abstract class ConstructorsStandingsLoader {
  /// Получает сырые данные зачёта конструкторов за сезон.
  static Future<BaseResponseModel> loadData({required String year}) => ApiLoader.get('$year/constructorStandings');
}
