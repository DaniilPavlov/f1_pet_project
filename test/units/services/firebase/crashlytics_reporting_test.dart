import 'dart:io';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/services/firebase/crashlytics_reporting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('shouldReportUncaughtErrorToCrashlytics', () {
    test('skips dio and socket errors', () {
      expect(
        shouldReportUncaughtErrorToCrashlytics(
          DioException(requestOptions: RequestOptions(path: '/test')),
        ),
        isFalse,
      );
      expect(shouldReportUncaughtErrorToCrashlytics(const SocketException('offline')), isFalse);
    });

    test('skips custom exception wrapping dio', () {
      expect(
        shouldReportUncaughtErrorToCrashlytics(
          CustomException(
            title: 'Error',
            parentException: DioException(requestOptions: RequestOptions(path: '/test')),
          ),
        ),
        isFalse,
      );
    });

    test('reports parse and unexpected errors', () {
      expect(shouldReportUncaughtErrorToCrashlytics(ResponseParseException('bad json')), isTrue);
      expect(shouldReportUncaughtErrorToCrashlytics(StateError('bug')), isTrue);
    });
  });
}
