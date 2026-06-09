import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';

abstract class LastRaceResultsLoader {
  static Future<BaseResponseModel> loadData() => ApiLoader.get('current/last/results');
}
