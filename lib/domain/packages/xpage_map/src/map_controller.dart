import 'dart:async';

class MapController {
  late final stream = _controller.stream;

  final _controller = StreamController<MapEvent>();

  void updateUserPosition() {
    _controller.add(MapEvent('updateUserPosition'));
  }

  void zoomIn() {
    _controller.add(MapEvent('zoomIn'));
  }

  void zoomOut() {
    _controller.add(MapEvent('zoomOut'));
  }

  void center() {
    _controller.add(MapEvent('center'));
  }

  void moveCameraTo(List<double> point) {
    _controller.add(MapEvent(
      'moveCameraTo',
      point,
    ));
  }

  void selectPlacemark(int point) {
    _controller.add(
      MapEvent(
        'selectPlacemark',
        point,
      ),
    );
  }
}

class MapEvent {
  final String type;
  final dynamic args;

  MapEvent(this.type, [this.args]);
}
