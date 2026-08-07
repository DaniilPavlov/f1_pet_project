import 'package:f1_pet_project/core/circuits/map/controllers/map_container_controller/map_container_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

void main() {
  final points = [const Point(latitude: 43.7347, longitude: 7.4206), const Point(latitude: 44, longitude: 8)];

  group('MapContainerController', () {
    test('keeps initial points', () {
      final controller = MapContainerController(points: points);
      expect(controller.points, hasLength(2));
    });

    test('updates points when list changes', () {
      final controller = MapContainerController(points: points)
        ..updatePoints([const Point(latitude: 1, longitude: 1)]);

      expect(controller.points, hasLength(1));
      expect(controller.points.first.latitude, 1);
    });
  });
}
