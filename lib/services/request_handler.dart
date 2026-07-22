import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/common/utils/platform_capabilities.dart';
import 'package:f1_pet_project/services/cache_interceptor.dart';
import 'package:f1_pet_project/services/http/app_dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// HTTP-клиент Jolpica через Dio (один экземпляр на приложение).
class RequestHandler {
  RequestHandler() {
    _dio = _createDio();
    _dio.interceptors.add(_cacheInterceptorWrapper());
  }

  final _cacheInterceptor = CacheInterceptor();
  late final Dio _dio;

  /// Сбрасывает in-memory HTTP-кэш (pull-to-refresh).
  void clearCache() => _cacheInterceptor.clear();

  Interceptor _cacheInterceptorWrapper() {
    return InterceptorsWrapper(
      onRequest: _cacheInterceptor.onRequest,
      onResponse: _cacheInterceptor.onResponse,
      onError: _cacheInterceptor.onError,
    );
  }

  /// GET к Jolpica с суффиксом `.json`.
  Future<Response<T>> get<T>(
    String path, {
    int limit = 100,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.get(
        '$path.json',
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: await _getOptions(options),
        queryParameters: <String, dynamic>{
          'limit': limit,
          ...?queryParameters,
        },
      );
    } on DioException catch (e) {
      logger.d('RequestHandler GET $path → ${e.response?.statusCode ?? e.type.name}');
      Error.throwWithStackTrace(e, StackTrace.current);
    }
  }

  Future<Options> _getOptions(Options? options) async {
    // Custom headers break Jolpica CORS in browsers that can reach the API.
    if (kIsWeb) {
      return options ?? Options();
    }

    final info = await PackageInfo.fromPlatform();
    final headers = <String, dynamic>{
      ...?options?.headers,
      'system': options?.headers?.containsKey('system') ?? false
          ? options!.headers!['system']
          : PlatformCapabilities.systemLabel,
      'version': info.version,
      'build-number': info.buildNumber,
    };

    return (options ?? Options()).copyWith(headers: headers);
  }

  Dio _createDio() => AppDio.jolpica();
}
