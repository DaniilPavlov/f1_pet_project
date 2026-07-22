import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Android/iOS: Hybrid Composition для MapKit.
void configureMapKitPlatform() {
  AndroidYandexMap.useAndroidViewSurface = true;
}
