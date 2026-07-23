import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Кэш GET Jolpica: память + SharedPreferences, offline-fallback при сетевых ошибках.
///
/// GoF Structural Decorator — поведение кэша «навешивается» на Dio через
/// interceptor, не меняя API клиента.
///
/// Refresh: [invalidate] → следующий запрос идёт в сеть, кэш остаётся на случай фейла.
class CacheInterceptor extends Interceptor {
  CacheInterceptor();

  static const _diskPrefix = 'jolpica_http_cache_v1:';

  final _memory = <Uri, Response<dynamic>>{};
  var _preferNetwork = false;

  void invalidate() => _preferNetwork = true;

  void clearMemory() {
    _memory.clear();
    _preferNetwork = false;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // GoF Behavioral Chain of Responsibility — либо отвечаем из кэша, либо next().
    if (_preferNetwork) {
      handler.next(options);
      return;
    }

    final cached = _memory[options.uri];
    if (cached != null) {
      handler.resolve(cached);
      return;
    }

    unawaited(_serveFromDiskOrContinue(options, handler));
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _memory[response.requestOptions.uri] = response;
    unawaited(_writeDisk(response.requestOptions.uri, response));
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!_isConnectivityError(err)) {
      handler.next(err);
      return;
    }
    unawaited(_serveCacheOnError(err, handler));
  }

  Future<void> _serveFromDiskOrContinue(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final disk = await _readDisk(options);
    if (disk != null) {
      _memory[options.uri] = disk;
      handler.resolve(disk);
      return;
    }
    handler.next(options);
  }

  Future<void> _serveCacheOnError(DioException err, ErrorInterceptorHandler handler) async {
    final uri = err.requestOptions.uri;
    final cached = _memory[uri] ?? await _readDisk(err.requestOptions);
    if (cached != null) {
      _memory[uri] = cached;
      if (kDebugMode) {
        logger.d('CacheInterceptor: offline cache for ${err.requestOptions.path}');
      }
      handler.resolve(cached);
      return;
    }
    handler.next(err);
  }

  Future<Response<dynamic>?> _readDisk(RequestOptions options) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('$_diskPrefix${options.uri}');
      if (raw == null) {
        return null;
      }
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Response<dynamic>(
        requestOptions: options,
        data: map['data'],
        statusCode: map['statusCode'] as int? ?? 200,
      );
    } on Object catch (error, stackTrace) {
      logger.w('CacheInterceptor disk read failed', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> _writeDisk(Uri uri, Response<dynamic> response) async {
    final data = response.data;
    if (data == null) {
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '$_diskPrefix$uri',
        jsonEncode(<String, dynamic>{
          'statusCode': response.statusCode ?? 200,
          'data': data,
        }),
      );
    } on Object catch (error, stackTrace) {
      logger.w('CacheInterceptor disk write failed', error: error, stackTrace: stackTrace);
    }
  }

  static bool _isConnectivityError(DioException err) => switch (err.type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.unknown => true,
    _ => false,
  };
}
