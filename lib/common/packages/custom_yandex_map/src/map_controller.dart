import 'dart:async';

/// Контроллер команд карты, передаваемых через поток событий.
class MapController {
  late final stream = _controller.stream;

  final _controller = StreamController<MapEvent>();

  /// Запрашивает обновление геопозиции пользователя.
  void updateUserPosition() {
    _controller.add(MapEvent('updateUserPosition'));
  }

  /// Увеличивает масштаб карты.
  void zoomIn() {
    _controller.add(MapEvent('zoomIn'));
  }

  /// Уменьшает масштаб карты.
  void zoomOut() {
    _controller.add(MapEvent('zoomOut'));
  }

  /// Центрирует камеру на текущих точках.
  void center() {
    _controller.add(MapEvent('center'));
  }

  /// Перемещает камеру к указанным координатам.
  void moveCameraTo(List<double> point) {
    _controller.add(MapEvent('moveCameraTo', point));
  }

  /// Выделяет метку по индексу.
  void selectPlacemark(int point) {
    _controller.add(MapEvent('selectPlacemark', point));
  }
}

/// Событие команды для управления картой.
class MapEvent {
  MapEvent(this.type, [this.args]);
  final String type;
  final dynamic args;
}
