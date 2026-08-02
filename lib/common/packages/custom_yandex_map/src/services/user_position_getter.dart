import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Сервис получения текущей геопозиции пользователя.
class UserPositionGetter {
  /// Возвращает координаты пользователя, запрашивая разрешения при необходимости.
  static Future<Point> getUserPosition({Function(Exception)? onGetUserPositionError}) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      final error = Exception('Нет разрешения на получение местоположения');
      onGetUserPositionError?.call(error);
      Error.throwWithStackTrace(error, StackTrace.current);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      final error = Exception('Нет разрешения на получение местоположения');
      onGetUserPositionError?.call(error);
      Error.throwWithStackTrace(error, StackTrace.current);
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      return Point(latitude: position.latitude, longitude: position.longitude);
    } catch (e) {
      Error.throwWithStackTrace(e, StackTrace.current);
    }
  }
}
