import 'dart:io';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/services/cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Синглтон для HTTP-запросов к API через Dio.
class RequestHandler {
  /// Возвращает единственный экземпляр обработчика запросов.
  factory RequestHandler() {
    final handler = _singleton;
    return handler;
  }

  RequestHandler._init() {
    _dio = _createDio();
    _dio!.interceptors.add(addInterceptors());
  }
  static final RequestHandler _singleton = RequestHandler._init();
  final _cacheInterceptor = CacheInterceptor();
  late Dio? _dio;

  /// Сбрасывает in-memory HTTP-кэш (pull-to-refresh).
  void clearCache() => _cacheInterceptor.clear();

  /// Подключает интерцепторы кэширования к клиенту Dio.
  Interceptor addInterceptors() {
    return InterceptorsWrapper(
      onRequest: _cacheInterceptor.onRequest,
      onResponse: _cacheInterceptor.onResponse,
      onError: _cacheInterceptor.onError,
    );
  }

  /// Выполняет GET-запрос к API с суффиксом `.json?limit=…`.
  Future<Response<T>> get<T>(
    String path, {
    int limit = 100,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    late Response<T> res;

    try {
      res = await _dio!.get(
        '$path.json?limit=$limit',
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: await _getOptions(options),
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      final result = e.response;
      debugPrint('statusCode get ($path): ${result?.statusCode}');
      Error.throwWithStackTrace(e, StackTrace.current);
    }
    return res;
  }

  /// Выполняет POST-запрос к API с суффиксом `.json`.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    late Response<T> res;

    try {
      res = await _dio!.post(
        '$path.json',
        data: data,
        queryParameters: queryParameters,
        options: await _getOptions(options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      final result = e.response;
      debugPrint('statusCode post ($path): ${result?.statusCode}');
      Error.throwWithStackTrace(e, StackTrace.current);
    }
    return res;
  }

  /// Выполняет PUT-запрос к указанному пути.
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    late Response<T> res;
    try {
      res = await _dio!.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: await _getOptions(options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      final result = e.response;
      debugPrint('statusCode put ($path): ${result?.statusCode}');
      Error.throwWithStackTrace(e, StackTrace.current);
    }

    return res;
  }

  /// Выполняет DELETE-запрос к указанному пути.
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return _dio!.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: await _getOptions(options),
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      final result = e.response;
      debugPrint('statusCode delete ($path): ${result?.statusCode}');
      Error.throwWithStackTrace(e, StackTrace.current);
    }
  }

  Future<Options> _getOptions(Options? options) async {
    final info = await PackageInfo.fromPlatform();
    final system = Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'another');
    return options != null
        ? options.copyWith(
            headers: options.headers != null
                ? (options.headers!..addAll(<String, dynamic>{
                    'system': options.headers!.containsKey('system') ? options.headers!['system'] : system,
                    'version': info.version,
                    'device-id': 'deviceID',
                    'build-number': info.buildNumber,
                  }))
                : <String, dynamic>{
                    'system': system,
                    'device-id': 'deviceID',
                    'version': info.version,
                    'build-number': info.buildNumber,
                  },
          )
        : Options(
            headers: <String, dynamic>{
              'version': info.version,
              'build-number': info.buildNumber,
              'device-id': 'deviceID',
              'system': system,
            },
          );
  }

  Dio _createDio() {
    return Dio(
      BaseOptions(
        baseUrl: StaticData.apiUrl,
        connectTimeout: const Duration(milliseconds: 20000),
        receiveTimeout: const Duration(milliseconds: 40000),
      ),
    );
  }
}
