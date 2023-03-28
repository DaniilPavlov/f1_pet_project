import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/domain/services/request_handler.dart';

abstract class ConstructorsChampionsLoader {
  static Future<BaseResponseModel> loadData() async {
    final rh = RequestHandler();

    final res = await rh.get<dynamic>('constructorStandings/1');
    return BaseResponseModel.fromJson(res.data as Map<String, dynamic>);
  }
}
