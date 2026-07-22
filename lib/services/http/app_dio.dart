import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:flutter/foundation.dart';

/// Фабрика Dio: общие таймауты (заголовки Jolpica задаёт [RequestHandler]).
///
/// GoF Creational Factory Method — создание продукта ([Dio]) делегировано
/// именованным методам (`jolpica` / `external`), которые задают конфигурацию
/// и возвращают готовый экземпляр, скрывая детали `BaseOptions` от вызывающего.
abstract final class AppDio {
  static const connectTimeout = Duration(milliseconds: 20000);
  static const receiveTimeout = Duration(milliseconds: 40000);

  static const espnConnectTimeout = Duration(milliseconds: 15000);
  static const espnReceiveTimeout = Duration(milliseconds: 20000);

  /// Jolpica F1 API (`baseUrl` = [StaticData.apiUrl]).
  static Dio jolpica() {
    final dio = Dio(
      BaseOptions(baseUrl: StaticData.apiUrl, connectTimeout: connectTimeout, receiveTimeout: receiveTimeout),
    );
    _attachDebugLogging(dio);
    return dio;
  }

  /// ESPN и прочие absolute-URL запросы без baseUrl.
  static Dio external({
    Duration connectTimeout = espnConnectTimeout,
    Duration receiveTimeout = espnReceiveTimeout,
    Map<String, dynamic>? headers,
  }) {
    final dio = Dio(BaseOptions(connectTimeout: connectTimeout, receiveTimeout: receiveTimeout, headers: headers));
    _attachDebugLogging(dio);
    return dio;
  }

  /// В debug логирует method/url/status без тел и заголовков (ответы большие).
  static void _attachDebugLogging(Dio dio) {
    if (!kDebugMode) {
      return;
    }
    dio.interceptors.add(LogInterceptor(requestHeader: false, responseHeader: false));
  }
}
