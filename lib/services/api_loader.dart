import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/request_handler.dart';

/// Базовый загрузчик данных с API.
abstract class ApiLoader {
  /// Загружает и парсит ответ API по указанному пути.
  static Future<BaseResponseModel> get(
    String path, {
    int limit = 100,
    int offset = 0,
  }) async {
    final res = await RequestHandler().get<dynamic>(
      path,
      limit: limit,
      queryParameters: offset > 0 ? <String, dynamic>{'offset': offset} : null,
    );
    return BaseResponseModel.fromJson(res.data as Map<String, dynamic>);
  }
}
