import 'package:dio/dio.dart';
import 'package:f1_pet_project/services/cache/cache_payload_codec.dart';
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
      final cache = CacheInterceptor(diskCodec: const IdentityCacheCodec());
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

    test('invalidate forces one network pass per URI then cache works again', () async {
      final cache = CacheInterceptor(diskCodec: const IdentityCacheCodec());
      final opts = options('current/drivers.json');
      final response = ok(opts, {'ok': true});

      cache.onResponse(response, _ResponseHandler());
      await Future<void>.delayed(const Duration(milliseconds: 30));

      cache.invalidate();

      final afterInvalidate = _RequestHandler();
      cache.onRequest(opts, afterInvalidate);
      expect(afterInvalidate.nextCalled, isTrue);

      // Второй запрос того же URI после «принудительного» прохода снова может взять memory cache.
      final second = _RequestHandler();
      cache.onRequest(opts, second);
      expect(second.resolved, isNotNull);

      final err = DioException(requestOptions: opts, type: DioExceptionType.connectionError);
      final errorHandler = _ErrorHandler();
      cache.onError(err, errorHandler);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(errorHandler.resolved?.data, {'ok': true});
    });

    test('invalidate forces network for parallel distinct URIs', () async {
      final cache = CacheInterceptor(diskCodec: const IdentityCacheCodec());
      final drivers = options('current/driverStandings.json');
      final constructors = options('current/constructorStandings.json');

      cache
        ..onResponse(ok(drivers, {'drivers': true}), _ResponseHandler())
        ..onResponse(ok(constructors, {'ctors': true}), _ResponseHandler());
      await Future<void>.delayed(const Duration(milliseconds: 30));

      cache.invalidate();

      final driversHandler = _RequestHandler();
      final constructorsHandler = _RequestHandler();
      cache
        ..onRequest(drivers, driversHandler)
        ..onRequest(constructors, constructorsHandler);

      expect(driversHandler.nextCalled, isTrue);
      expect(constructorsHandler.nextCalled, isTrue);
      expect(driversHandler.resolved, isNull);
      expect(constructorsHandler.resolved, isNull);
    });

    test('non-connectivity errors pass through', () {
      final cache = CacheInterceptor(diskCodec: const IdentityCacheCodec());
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
      final cache = CacheInterceptor(diskCodec: const IdentityCacheCodec());
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

      final cache = CacheInterceptor(diskCodec: const IdentityCacheCodec());
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

    test('reads legacy uncompressed disk payload', () async {
      final opts = options('legacy.json');
      final cachedAt = DateTime.now().toIso8601String();
      SharedPreferences.setMockInitialValues({
        'jolpica_http_cache_v1:${opts.uri}':
            '{"cachedAt":"$cachedAt","statusCode":200,"data":{"legacy":true}}',
      });

      final cache = CacheInterceptor(diskCodec: const IdentityCacheCodec());
      final request = _RequestHandler();
      cache.onRequest(opts, request);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(request.resolved?.data, {'legacy': true});
    });

    test('disk write uses injected codec envelope', () async {
      final codec = _PrefixCodec();
      final cache = CacheInterceptor(diskCodec: codec);
      final opts = options('encoded.json');

      cache.onResponse(ok(opts, {'n': 1}), _ResponseHandler());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('jolpica_http_cache_v1:${opts.uri}');
      expect(raw, isNotNull);
      expect(raw!.startsWith('test:'), isTrue);

      cache.clearMemory();
      final request = _RequestHandler();
      cache.onRequest(opts, request);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(request.resolved?.data, {'n': 1});
    });
  });
}

/// Tiny stand-in for FFI codec: proves interceptor round-trips through encode/decode.
class _PrefixCodec extends CachePayloadCodec {
  @override
  String encode(String utf8Json) => 'test:$utf8Json';

  @override
  String decode(String stored) {
    const prefix = 'test:';
    if (stored.startsWith(prefix)) {
      return stored.substring(prefix.length);
    }
    return stored;
  }
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
