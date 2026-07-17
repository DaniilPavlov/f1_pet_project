import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Загрузчик турнирной таблицы конструкторов из API.
abstract class CurrentConstructorsStandingsLoader {
  /// Запрашивает актуальные standings конструкторов.
  static Future<BaseResponseModel> loadData() => ApiLoader.get('current/constructorStandings');
}
