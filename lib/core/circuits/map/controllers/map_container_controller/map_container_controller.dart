import 'package:collection/collection.dart';
import 'package:f1_pet_project/common/packages/custom_yandex_map/src/map_controller.dart';
import 'package:mobx/mobx.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as ym;

part 'map_container_controller.g.dart';

/// MobX-контроллер контейнера карты.
class MapContainerController = MapContainerControllerBase with _$MapContainerController;

/// Управляет точками на карте и действиями пользователя.
abstract class MapContainerControllerBase with Store {
  MapContainerControllerBase({required List<ym.Point> points}) : _points = List.of(points);

  final mapController = MapController();
  final _deepEq = const DeepCollectionEquality().equals;

  List<ym.Point> _points;

  @observable
  ObservableList<ym.Point> listPoints = ObservableList<ym.Point>();

  /// Инициализирует список точек на карте.
  @action
  void init() {
    listPoints.replaceRange(0, listPoints.length, _points);
  }

  /// Обновляет точки на карте при изменении входных данных.
  @action
  void updatePoints(List<ym.Point> points) {
    if (!_deepEq(_points, points)) {
      _points = List.of(points);
      listPoints.replaceRange(0, listPoints.length, _points);
    }
  }

  /// Запрашивает обновление позиции пользователя на карте.
  void onUserLocationPressed() {
    mapController.updateUserPosition();
  }
}
