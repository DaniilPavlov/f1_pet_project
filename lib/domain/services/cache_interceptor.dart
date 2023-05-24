import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CacheInterceptor extends Interceptor {
  final _cache = <Uri, Response>{};
  CacheInterceptor();

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

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _cache[response.requestOptions.uri] = response;
    super.onResponse(response, handler);
  }

// TODO(info): now doesn't invoke because of the if/else condition in [onRequest]
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
