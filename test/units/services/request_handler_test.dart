import 'package:dio/dio.dart';
import 'package:f1_pet_project/services/request_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    PackageInfo.setMockInitialValues(
      appName: 'f1_pet_project',
      packageName: 'com.example.f1',
      version: '1.2.3',
      buildNumber: '42',
      buildSignature: '',
    );
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('RequestHandler', () {
    test('invalidateCache is safe to call', () {
      final handler = RequestHandler();
      expect(handler.invalidateCache, returnsNormally);
    });

    test('get appends .json, limit and User-Agent headers', () async {
      RequestOptions? seen;
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            seen = options;
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                data: {
                  'MRData': {'total': '0'},
                },
                statusCode: 200,
              ),
            );
          },
        ),
      );

      final response = await RequestHandler(
        dio: dio,
      ).get<Map<String, dynamic>>('current/drivers', limit: 30, queryParameters: {'offset': 10});

      expect(response.statusCode, 200);
      expect(seen!.path, 'current/drivers.json');
      expect(seen!.queryParameters['limit'], 30);
      expect(seen!.queryParameters['offset'], 10);
      expect(seen!.headers['User-Agent'], contains('1.2.3'));
      expect(seen!.headers['version'], '1.2.3');
      expect(seen!.headers['build-number'], '42');
      expect(seen!.headers['system'], isNotNull);
    });

    test('get rethrows DioException', () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(requestOptions: options, type: DioExceptionType.connectionError, message: 'offline'),
            );
          },
        ),
      );

      await expectLater(RequestHandler(dio: dio).get('current/drivers'), throwsA(isA<DioException>()));
    });
  });
}
