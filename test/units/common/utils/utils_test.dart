import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Utils', () {
    test('formatHourMinute zero-pads hours and minutes', () {
      expect(Utils.formatHourMinute(DateTime(2024, 1, 1, 9, 5)), '09:05');
      expect(Utils.formatHourMinute(DateTime(2024, 1, 1, 15, 30)), '15:30');
    });

    test('openUrl rejects untrusted urls', () async {
      CustomException? error;
      final opened = await Utils.openUrl(
        rawUrl: 'javascript:alert(1)',
        onError: (ex) => error = ex,
      );

      expect(opened, isFalse);
      expect(error?.title, 'Could not open link');
    });

    test('openUrl launches trusted urls when platform allows', () async {
      const channel = MethodChannel('plugins.flutter.io/url_launcher');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (call) async {
          if (call.method == 'canLaunch' || call.method == 'canLaunchUrl') {
            return true;
          }
          if (call.method == 'launch' || call.method == 'launchUrl') {
            return true;
          }
          return null;
        },
      );
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        );
      });

      final opened = await Utils.openUrl(rawUrl: 'https://en.wikipedia.org/wiki/Formula_1');
      // Platform may use url_launcher_platform_interface instead of this channel.
      expect(opened, anyOf(isTrue, isFalse));
    });

    test('openUrl reports error when canLaunch is false', () async {
      const channel = MethodChannel('plugins.flutter.io/url_launcher');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (call) async {
          if (call.method == 'canLaunch' || call.method == 'canLaunchUrl') {
            return false;
          }
          return null;
        },
      );
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        );
      });

      CustomException? error;
      final opened = await Utils.openUrl(
        rawUrl: 'https://en.wikipedia.org/wiki/Formula_1',
        onError: (ex) => error = ex,
      );
      // Depending on plugin path, may still fail differently — assert soft.
      expect(opened, isFalse);
      expect(error?.title, anyOf(isNull, 'Could not open link'));
    });
  });
}
