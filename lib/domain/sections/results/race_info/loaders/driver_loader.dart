import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/domain/services/request_handler.dart';

abstract class DriverLoader {
  static Future<BaseResponseRepository> loadData({
    required String driverId,
  }) async {
    final rh = RequestHandler();

    final res = await rh.get<dynamic>('drivers/$driverId');
    return BaseResponseRepository.fromJson(res.data as Map<String, dynamic>);
  }
}
