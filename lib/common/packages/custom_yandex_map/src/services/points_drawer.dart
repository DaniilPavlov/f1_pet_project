import 'dart:math';

import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Сервис создания меток на карте.
class PointsDrawer {
  static final rng = Random();

  /// Формирует список меток с обработчиком нажатия.
  static List<PlacemarkMapObject> getPoints({
    required List<Point> points,
    Function(int)? onTap,
    PlacemarkIcon? icon,
    PlacemarkIcon? selectedIcon,
    int? selectedIndex,
  }) {
    return List<PlacemarkMapObject>.generate(points.length, (i) {
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
    });
  }
}
