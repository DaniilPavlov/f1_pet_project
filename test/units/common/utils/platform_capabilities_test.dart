import 'package:f1_pet_project/common/utils/platform_capabilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    PlatformCapabilities.debugHasYandexMapOverride = null;
  });

  group('PlatformCapabilities', () {
    test('systemLabel follows target platform', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(PlatformCapabilities.systemLabel, 'android');
      expect(PlatformCapabilities.hasHomeWidgets, isTrue);
      expect(PlatformCapabilities.hasLocalNotifications, isTrue);
      expect(PlatformCapabilities.hasYandexMap, isTrue);
      expect(PlatformCapabilities.isCupertino, isFalse);

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(PlatformCapabilities.systemLabel, 'ios');
      expect(PlatformCapabilities.isCupertino, isTrue);
      expect(PlatformCapabilities.hasYandexMap, isTrue);

      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      expect(PlatformCapabilities.systemLabel, 'another');
      expect(PlatformCapabilities.hasHomeWidgets, isFalse);
      expect(PlatformCapabilities.hasYandexMap, isFalse);

      PlatformCapabilities.debugHasYandexMapOverride = true;
      expect(PlatformCapabilities.hasYandexMap, isTrue);
      PlatformCapabilities.debugHasYandexMapOverride = null;
    });
  });
}
