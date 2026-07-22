import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:flutter/foundation.dart';

/// In-memory кэш успешных GET-ответов Dio (по URI).
///
/// GoF Structural Decorator — поведение кэша «навешивается» на Dio через
/// interceptor, не меняя API `get` у [RequestHandler].
class CacheInterceptor extends Interceptor {
  CacheInterceptor();
  final _cache = <Uri, Response<dynamic>>{};

  /// Отдаёт кэш или пропускает запрос дальше.
  ///
  /// GoF Behavioral Chain of Responsibility — запрос идёт по цепочке
  /// interceptor'ов: либо звено само отвечает (`resolve`), либо передаёт
  /// дальше (`next`).
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

  /// Логирует ошибку; кэш при ошибке не подменяет ответ (это делает [onRequest]).
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      logger.d('CacheInterceptor.onError: ${err.response?.statusCode ?? err.type.name} ${err.requestOptions.path}');
    }
    handler.next(err);
  }

  /// Очищает in-memory кэш (для pull-to-refresh).
  void clear() => _cache.clear();
}
