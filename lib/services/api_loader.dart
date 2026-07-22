import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/request_handler.dart';

/// Тонкая обёртка над [RequestHandler]: GET + парсинг [BaseResponseModel].
///
/// Handler задаётся один раз из `main` через [configure] (не DI Provider).
abstract class ApiLoader {
  static RequestHandler? _handler;

  /// Привязывает Jolpica [RequestHandler] (вызывать из `main` до запросов).
  static void configure(RequestHandler handler) {
    _handler = handler;
  }

  static RequestHandler get _requestHandler {
    final handler = _handler;
    if (handler == null) {
      throw StateError('ApiLoader.configure(RequestHandler) was not called');
    }
    return handler;
  }

  /// GET по path Jolpica и парсинг ответа.
  static Future<BaseResponseModel> get(
    String path, {
    int limit = 100,
    int offset = 0,
  }) async {
    final res = await _requestHandler.get<dynamic>(
      path,
      limit: limit,
      queryParameters: offset > 0 ? <String, dynamic>{'offset': offset} : null,
    );
    return BaseResponseModel.fromJson(res.data as Map<String, dynamic>);
  }
}
