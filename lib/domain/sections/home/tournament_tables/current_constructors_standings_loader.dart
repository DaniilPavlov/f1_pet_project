import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/domain/services/request_handler.dart';

abstract class CurrentConstructorsStandingsLoader {
  static Future<BaseResponseModel> loadData() async {
    final rh = RequestHandler();
    final res = await rh.get<dynamic>('current/constructorStandings');
    return BaseResponseModel.fromJson(res.data as Map<String, dynamic>);
  }
}
