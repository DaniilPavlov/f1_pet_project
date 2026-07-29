import 'package:flutter/foundation.dart';

/// Возможности платформы: что доступно на web vs mobile.
abstract final class PlatformCapabilities {
  /// Override for widget tests (MapKit is unavailable in the Flutter test VM).
  @visibleForTesting
  static bool? debugHasYandexMapOverride;

  /// Yandex MapKit — только Android/iOS.
  static bool get hasYandexMap =>
      debugHasYandexMapOverride ??
      (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS));

  /// Локальные push-напоминания о сессиях — только Android/iOS.
  static bool get hasLocalNotifications => !kIsWeb;

  /// Android / iOS home screen widgets (MethodChannel + AppWidget / WidgetKit).
  static bool get hasHomeWidgets =>
      !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

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
