import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Интерцептор Dio для кэширования ответов в памяти.
class CacheInterceptor extends Interceptor {
  /// Создаёт интерцептор с пустым in-memory кэшем.
  CacheInterceptor();
  final _cache = <Uri, Response<dynamic>>{};

  /// Возвращает закэшированный ответ или передаёт запрос дальше.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final cached = _cache[options.uri];
    if (cached != null) {
      handler.resolve(cached);
      return;
    }
    handler.next(options);
  }

  /// Сохраняет успешный ответ в кэш.
  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _cache[response.requestOptions.uri] = response;
    handler.next(response);
  }

  /// Логирует ошибку. Кэш при ошибке не отдаём — его уже отдаёт [onRequest].
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('onError: ${err.response?.statusCode ?? err.type.name} ${err.requestOptions.path}');
    }
    handler.next(err);
  }

  /// Очищает in-memory кэш (для pull-to-refresh).
  void clear() => _cache.clear();
}
