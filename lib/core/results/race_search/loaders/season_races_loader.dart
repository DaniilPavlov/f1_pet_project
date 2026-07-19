import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

/// Календарь гонок выбранного сезона (`/{season}`).
abstract class SeasonRacesLoader {
  static Future<BaseResponseModel> loadData({required String year}) => ApiLoader.get(year);
}
