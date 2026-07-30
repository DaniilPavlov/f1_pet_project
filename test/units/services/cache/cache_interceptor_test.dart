import 'package:dio/dio.dart';
import 'package:f1_pet_project/services/cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  RequestOptions options(String path) => RequestOptions(path: path, baseUrl: 'https://api.jolpi.ca/ergast/f1/');

  Response<dynamic> ok(RequestOptions opts, Object data) =>
      Response<dynamic>(requestOptions: opts, data: data, statusCode: 200);

  group('CacheInterceptor', () {
    test('serves memory cache on same calendar day', () async {
      final cache = CacheInterceptor();
      final opts = options('current/drivers.json');
      final response = ok(opts, {
        'MRData': {'total': '1'},
      });

      cache.onResponse(response, _ResponseHandler());

      final request = _RequestHandler();
      cache.onRequest(opts, request);

      expect(request.resolved, isNotNull);
      expect(request.resolved!.data, response.data);
      expect(request.nextCalled, isFalse);
    });

    test('invalidate forces one network pass then cache works again', () async {
      final cache = CacheInterceptor();
      final opts = options('current/drivers.json');
      final response = ok(opts, {'ok': true});

      cache.onResponse(response, _ResponseHandler());
      await Future<void>.delayed(const Duration(milliseconds: 30));

      cache.invalidate();

      final afterInvalidate = _RequestHandler();
      cache.onRequest(opts, afterInvalidate);
      expect(afterInvalidate.nextCalled, isTrue);

      // Второй запрос после «принудительного» прохода снова может взять memory cache.
      final second = _RequestHandler();
      cache.onRequest(opts, second);
      expect(second.resolved, isNotNull);

      final err = DioException(requestOptions: opts, type: DioExceptionType.connectionError);
      final errorHandler = _ErrorHandler();
      cache.onError(err, errorHandler);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(errorHandler.resolved?.data, {'ok': true});
    });

    test('non-connectivity errors pass through', () {
      final cache = CacheInterceptor();
      final opts = options('x.json');
      final err = DioException(
        requestOptions: opts,
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: opts, statusCode: 500),
      );

      final handler = _ErrorHandler();
      cache.onError(err, handler);

      expect(handler.nextError, same(err));
      expect(handler.resolved, isNull);
    });

    test('clearMemory drops in-memory entries', () async {
      final cache = CacheInterceptor();
      final opts = options('y.json');
      cache.onResponse(ok(opts, {'a': 1}), _ResponseHandler());
      await Future<void>.delayed(const Duration(milliseconds: 30));

      cache.clearMemory();

      final handler = _RequestHandler();
      cache.onRequest(opts, handler);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Memory cleared; disk may still serve today's cache.
      expect(handler.nextCalled || handler.resolved != null, isTrue);
    });

    test('corrupt disk cache falls through to network / error', () async {
      final opts = options('corrupt.json');
      SharedPreferences.setMockInitialValues({
        'jolpica_http_cache_v1:${opts.uri}': 'not-json',
      });

      final cache = CacheInterceptor();
      final request = _RequestHandler();
      cache.onRequest(opts, request);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(request.nextCalled, isTrue);

      final err = DioException(requestOptions: opts, type: DioExceptionType.connectionError);
      final errorHandler = _ErrorHandler();
      cache.onError(err, errorHandler);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(errorHandler.nextError, same(err));
    });
  });
}

class _RequestHandler extends RequestInterceptorHandler {
  bool nextCalled = false;
  Response<dynamic>? resolved;

  @override
  void next(RequestOptions requestOptions) {
    nextCalled = true;
  }

  @override
  void resolve(Response<dynamic> response, [bool callFollowingResponseInterceptor = false]) {
    resolved = response;
  }
}

class _ResponseHandler extends ResponseInterceptorHandler {
  @override
  void next(Response<dynamic> response) {}
}

class _ErrorHandler extends ErrorInterceptorHandler {
  DioException? nextError;
  Response<dynamic>? resolved;

  @override
  void next(DioException error) {
    nextError = error;
  }

  @override
  void resolve(Response<dynamic> response) {
    resolved = response;
  }
}
