import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/domain/services/request_handler.dart';

abstract class QualifyingResultsLoader {
  static Future<BaseResponseModel> loadData({
    required String year,
    required String round,
  }) async {
    final rh = RequestHandler();

    final res = await rh.get<dynamic>('$year/$round/qualifying');
    return BaseResponseModel.fromJson(res.data as Map<String, dynamic>);
  }
}
