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
    _dio = AppDio.jolpica();
    _dio.interceptors.add(_cache);
  }

  final _cache = CacheInterceptor();
  late final Dio _dio;

  /// Pull-to-refresh: следующий запрос в сеть, кэш остаётся для офлайна.
  void invalidateCache() => _cache.invalidate();

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
        options: await _options(options),
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

  Future<Options> _options(Options? options) async {
    if (kIsWeb) {
      return options ?? Options();
    }

    final info = await PackageInfo.fromPlatform();
    return (options ?? Options()).copyWith(
      headers: <String, dynamic>{
        ...?options?.headers,
        'system': options?.headers?['system'] ?? PlatformCapabilities.systemLabel,
        'version': info.version,
        'build-number': info.buildNumber,
      },
    );
  }
}
