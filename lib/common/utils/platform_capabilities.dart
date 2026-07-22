import 'package:flutter/foundation.dart';

/// Возможности платформы: что доступно на web vs mobile.
abstract final class PlatformCapabilities {
  /// Yandex MapKit — только Android/iOS.
  static bool get hasYandexMap => !kIsWeb;

  /// Локальные push-напоминания о сессиях — только Android/iOS.
  static bool get hasLocalNotifications => !kIsWeb;

  /// Метка `system` для User-Agent / headers Jolpica.
  static String get systemLabel {
    if (kIsWeb) {
      return 'web';
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      _ => 'another',
    };
  }

  static bool get isCupertino => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
}
