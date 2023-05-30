// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// User position service.
class UserPositionGetter {
  static Future<Point> getUserPosition({
    Function(Exception)? onGetUserPositionError,
  }) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // onError
      onGetUserPositionError?.call(
        Exception(
          'Нет разрешения на получение местоположения',
        ),
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // onError
        onGetUserPositionError?.call(
          Exception(
            'Нет разрешения на получение местоположения',
          ),
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // onError
      onGetUserPositionError?.call(
        Exception(
          'Нет разрешения на получение местоположения',
        ),
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition();

      return Point(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      Error.throwWithStackTrace(
        e,
        StackTrace.current,
      );
    }
  }
}
