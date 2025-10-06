import 'package:f1_pet_project/domain/packages/custom_yandex_map/src/wm/services/geometry_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Camera service.
class CameraServices {
  /// Center on list of points.
  static Future<void> setCenterOn<V>(List<V> list, {YandexMapController? controller}) async {
    if (list.isEmpty) return;

    await Future<void>.delayed(const Duration(milliseconds: 200));

    Geometry? geometry;

    if (list is List<Point>) {
      geometry = GeometryService.getGeometry(list as List<Point>);
    } else if (list is List<PlacemarkMapObject>) {
      geometry = GeometryService.getGeometry((list as List<PlacemarkMapObject>).map((e) => e.point).toList());
    } else {
      return;
    }

    await Future<void>.delayed(
      const Duration(milliseconds: 200),
      () async => controller?.moveCamera(CameraUpdate.newGeometry(geometry!)),
    );
  }

  /// Navigate to point.
  static Future<void> moveTo(Point point, {YandexMapController? controller}) async {
    await controller?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 16,
          target: Point(latitude: point.latitude - 0.001, longitude: point.longitude),
        ),
      ),
      animation: const MapAnimation(duration: 1),
    );
  }
}
