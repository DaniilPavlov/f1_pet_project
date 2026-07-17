import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Интерцептор Dio для кэширования ответов в памяти.
class CacheInterceptor extends Interceptor {
  /// Создаёт интерцептор с пустым in-memory кэшем.
  CacheInterceptor();
  final _cache = <Uri, Response>{};

  /// Возвращает закэшированный ответ или передаёт запрос дальше.
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // TODO(info): change this condition if will be needed
    if (_cache[options.uri] != null) {
      debugPrint(options.uri.path);
      handler.resolve(_cache[options.uri]!);
    } else {
      handler.next(options);
    }
    // super.onRequest(options, handler);
  }

  /// Сохраняет успешный ответ в кэш.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _cache[response.requestOptions.uri] = response;
    super.onResponse(response, handler);
  }

  /// Подставляет закэшированный ответ при сетевых ошибках.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    var dioError = err;
    final status = err.response?.statusCode;
    debugPrint('onError: ${status ?? err.type.name} ${err.requestOptions.path}');
    if (err.type == DioExceptionType.connectionTimeout || err.type == DioExceptionType.unknown) {
      final cachedResponse = _cache[err.requestOptions.uri];
      if (cachedResponse != null) {
        dioError = err.copyWith(response: cachedResponse);
      }
    }
    super.onError(dioError, handler);
  }
}
