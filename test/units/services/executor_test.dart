import 'package:dio/dio.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/exceptions/success_false.dart';
import 'package:f1_pet_project/services/executor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('execute', () {
    test('success runs before → processing → after → onSuccess', () async {
      final steps = <String>[];

      await execute(
        () async {
          steps.add('processing');
          return 42;
        },
        before: () => steps.add('before'),
        after: () => steps.add('after'),
        onSuccess: (data) => steps.add('success:$data'),
        onError: (_) => steps.add('error'),
      );

      expect(steps, ['before', 'processing', 'after', 'success:42']);
    });

    test('ResponseParseException maps to onError without retry', () async {
      var attempts = 0;
      CustomException? caught;

      await execute(
        () async {
          attempts++;
          throw ResponseParseException('bad json');
        },
        maxAttempts: 3,
        onError: (e) => caught = e,
        attemptsDelayCallback: (_) => Duration.zero,
      );

      expect(attempts, 1);
      expect(caught, isNotNull);
      expect(caught!.parentException, isA<ResponseParseException>());
    });

    test('retries Dio 500 then succeeds', () async {
      var attempts = 0;

      await execute(
        () async {
          attempts++;
          if (attempts < 3) {
            throw DioException(
              requestOptions: RequestOptions(path: '/x'),
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: RequestOptions(path: '/x'),
                statusCode: 500,
              ),
            );
          }
          return 'ok';
        },
        maxAttempts: 3,
        attemptsDelayCallback: (_) => Duration.zero,
        onSuccess: (data) => expect(data, 'ok'),
      );

      expect(attempts, 3);
    });

    test('does not retry Dio 400', () async {
      var attempts = 0;

      await execute(
        () async {
          attempts++;
          throw DioException(
            requestOptions: RequestOptions(path: '/x'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/x'),
              statusCode: 400,
            ),
          );
        },
        maxAttempts: 3,
        attemptsDelayCallback: (_) => Duration.zero,
        onError: (e) => expect(e.parentException, isA<DioException>()),
      );

      expect(attempts, 1);
    });

    test('connection DioException uses no-connection copy', () async {
      CustomException? caught;

      await execute(
        () async {
          throw DioException(
            requestOptions: RequestOptions(path: '/x'),
            type: DioExceptionType.connectionTimeout,
          );
        },
        onError: (e) => caught = e,
      );

      expect(caught?.title, isNotEmpty);
      expect(caught?.parentException, isA<DioException>());
    });

    test('429 DioException maps to too-many-requests', () async {
      CustomException? caught;

      await execute(
        () async {
          throw DioException(
            requestOptions: RequestOptions(path: '/x'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/x'),
              statusCode: 429,
            ),
          );
        },
        onError: (e) => caught = e,
      );

      expect(caught?.parentException, isA<DioException>());
      expect((caught!.parentException! as DioException).response?.statusCode, 429);
    });

    test('SuccessFalse and generic errors map to onError', () async {
      CustomException? first;
      await execute(
        () async => throw SuccessFalse('nope'),
        onError: (e) => first = e,
      );
      expect(first?.parentException, isA<SuccessFalse>());

      CustomException? second;
      await execute(
        () async => throw StateError('boom'),
        onError: (e) => second = e,
      );
      expect(second, isNotNull);
    });
  });
}
