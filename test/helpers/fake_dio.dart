import 'package:dio/dio.dart';

/// Dio that resolves requests via [onRequest] without hitting the network.
Dio fakeDio(Object Function(RequestOptions options) respond) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        try {
          final body = respond(options);
          if (body is DioException) {
            handler.reject(body);
            return;
          }
          if (body is Exception) {
            handler.reject(
              DioException(requestOptions: options, error: body, type: DioExceptionType.unknown),
            );
            return;
          }
          handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              data: body,
              statusCode: 200,
            ),
          );
        } on Object catch (e) {
          handler.reject(
            DioException(requestOptions: options, error: e, type: DioExceptionType.unknown),
          );
        }
      },
    ),
  );
  return dio;
}
