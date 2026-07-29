import 'package:dio/dio.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/services/jolpica_error_body_fallback.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/jolpica_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('PonnamKarthik/fluttertoast'),
      (call) async => true,
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('PonnamKarthik/fluttertoast'),
      null,
    );
  });

  group('withErrorBodyFallback', () {
    test('returns successful response as-is', () async {
      final expected = BaseResponseModel.fromJson({
        'MRData': JolpicaFixtures.seasonsMrData(),
      });

      final result = await withErrorBodyFallback(() async => expected);
      expect(result, same(expected));
    });

    test('parses DioException JSON body as success', () async {
      final body = {
        'MRData': JolpicaFixtures.seasonsMrData(),
      };

      final result = await withErrorBodyFallback(() async {
        throw DioException(
          requestOptions: RequestOptions(path: 'x'),
          response: Response(
            requestOptions: RequestOptions(path: 'x'),
            data: body,
            statusCode: 429,
          ),
        );
      });

      expect(result, isNotNull);
      expect(result!.mrData, isA<Map>());
    });

    test('rethrows DioException without map body', () async {
      expect(
        () => withErrorBodyFallback(() async {
          throw DioException(
            requestOptions: RequestOptions(path: 'x'),
            response: Response(
              requestOptions: RequestOptions(path: 'x'),
              data: 'rate limited',
              statusCode: 429,
            ),
          );
        }),
        throwsA(isA<DioException>()),
      );
    });

    test('rethrows non-Dio errors', () async {
      expect(
        () => withErrorBodyFallback(() async => throw StateError('boom')),
        throwsA(isA<StateError>()),
      );
    });
  });
}
