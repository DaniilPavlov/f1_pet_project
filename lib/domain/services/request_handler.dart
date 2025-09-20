import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:f1_pet_project/domain/services/cache_interceptor.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart' as pp;

class RequestHandler {
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
  CookieManager? _cookieManager;
  late Dio? _dio;

  Interceptor addInterceptors() {
    return InterceptorsWrapper(
      onRequest: _cacheInterceptor.onRequest,
      onResponse: _cacheInterceptor.onResponse,
      onError: _cacheInterceptor.onError,
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    late Response<T> res;

    try {
      res = await _dio!.get(
        // this api needs '.json?limit=100'
        '$path.json?limit=100',
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

    // res.requestOptions.headers.forEach((key, dynamic value) {
    //   debugPrint('cookie: $key = $value');
    // });

    // _checkAccess(res);

    return res;
  }

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
        // path,
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
    // _checkAccess(res);

    return res;
  }

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
                ? (options.headers!
                  ..addAll(
                    <String, dynamic>{
                      'system': options.headers!.containsKey('system') ? options.headers!['system'] : system,
                      'version': info.version,
                      'device-id': 'deviceID',
                      'build-number': info.buildNumber,
                    },
                  ))
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
    final dio = Dio(
      BaseOptions(
        baseUrl: StaticData.apiUrl,
        connectTimeout: const Duration(milliseconds: 20000),
        receiveTimeout: const Duration(milliseconds: 40000),
      ),
    );

    if (_cookieManager == null) {
      try {
        pp.getApplicationDocumentsDirectory().then((dir) {
          _cookieManager = CookieManager(
            PersistCookieJar(
              storage: FileStorage('${dir.path}/.cookie/'),
            ),
          );
          dio.interceptors.add(_cookieManager!);
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return dio;
  }
}
