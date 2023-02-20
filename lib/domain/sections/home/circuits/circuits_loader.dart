import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/domain/services/request_handler.dart';

abstract class CircuitsLoader {
  static Future<BaseResponseRepository> loadData() async {
    final rh = RequestHandler();

    final res = await rh.get<dynamic>('circuits');
    return BaseResponseRepository.fromJson(res.data as Map<String, dynamic>);
  }
}
