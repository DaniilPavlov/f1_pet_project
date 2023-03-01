// ignore_for_file: avoid_annotating_with_dynamic, avoid_catches_without_on_clauses, no_leading_underscores_for_local_identifiers

import 'package:dio/dio.dart';
import 'package:f1_pet_project/utils/constants/static.dart';

class RequestHandler {
  static final RequestHandler _singleton = RequestHandler._init();
  Dio? _dio;
  factory RequestHandler() {
    final handler = _singleton;

    return handler;
  }

  RequestHandler._init() {
    _dio = _createDio();
  }

  // ignore: member-ordering-extended

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    String? baseUrl,
  }) async {
    // late Response<T> res;

    _dio?.options = _dio!.options.copyWith(
      baseUrl: baseUrl ?? StaticData.apiUrl,
    );

    final res = await _dio!.get<T>(
      '$path.json?limit=100',
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
    );

    // final base = BaseResponseRepository.fromJson(
    //   res.data!,
    // );

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
    final res = await _dio!.post<T>(
      '$path.json',
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    // final base = BaseResponseRepository.fromJson(
    //   res.data!,
    // );

    return res;
  }

  Dio _createDio() {
    return Dio(
      BaseOptions(
        baseUrl: StaticData.apiUrl,
        connectTimeout: 20000,
        receiveTimeout: 40000,
      ),
    );
  }
}
