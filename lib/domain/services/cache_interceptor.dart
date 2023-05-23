import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CacheInterceptor extends Interceptor {
  final _cache = <Uri, Response>{};
  CacheInterceptor();

  // @override
  // void onRequest(
  //   RequestOptions options,
  //   RequestInterceptorHandler handler,
  // ) {
  //   super.onRequest(options, handler);
  // }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _cache[response.requestOptions.uri] = response;
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    var dioError = err;
    debugPrint('onError: $err');
    if (err.type == DioErrorType.connectionTimeout ||
        err.type == DioErrorType.unknown) {
      final cachedResponse = _cache[err.requestOptions.uri];
      if (cachedResponse != null) {
        dioError = err.copyWith(response: cachedResponse);
        // handler.resolve(cachedResponse);
        // return cachedResponse;
      }
    }
    // return err;
    super.onError(dioError, handler);
  }
}
