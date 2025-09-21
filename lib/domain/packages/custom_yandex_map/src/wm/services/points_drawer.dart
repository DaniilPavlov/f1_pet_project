import 'dart:math';
import 'package:flutter/material.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Points drawer service.
class PointsDrawer {
  static final rng = Random();

  static List<PlacemarkMapObject> getPoints({
    required List<Point> points,
    Function(int)? onTap,
    PlacemarkIcon? icon,
    PlacemarkIcon? selectedIcon,
    int? selectedIndex,
  }) {
    debugPrint('qweQEQWEQWEQWEQWE ${points.length}');
    return List<PlacemarkMapObject>.generate(
      points.length,
      (i) {
        final rnd = rng.nextInt(200);
        final placemarkId = 'p_${i}_${rnd}_${points[i]}';
        return PlacemarkMapObject(
          onTap: (mapObject, point) {
            onTap?.call(i);
          },
          opacity: 1,
          mapId: MapObjectId(placemarkId),
          point: points[i],
          icon: i == selectedIndex ? selectedIcon : icon,
        );
      },
    );
  }
}
