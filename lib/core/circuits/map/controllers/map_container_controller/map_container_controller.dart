import 'package:f1_pet_project/common/packages/custom_yandex_map/src/map_controller.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as ym;

/// Держатель [MapController] для [MapContainer] (без Riverpod — UI не подписывается на state).
class MapContainerController {
  MapContainerController({required List<ym.Point> points}) : _points = List.of(points);

  final mapController = MapController();

  List<ym.Point> _points;

  List<ym.Point> get points => List.unmodifiable(_points);

  /// Обновляет точки при изменении входных данных виджета.
  void updatePoints(List<ym.Point> points) {
    _points = List.of(points);
  }

  /// Запрашивает обновление позиции пользователя на карте.
  void onUserLocationPressed() {
    mapController.updateUserPosition();
  }
}
