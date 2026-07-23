import 'package:f1_pet_project/core/circuits/map/controllers/map_container_controller/map_container_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../mobx/mobx_testing.dart';

void main() {
  final points = [const Point(latitude: 43.7347, longitude: 7.4206), const Point(latitude: 44, longitude: 8)];

  group('MapContainerController', () {
    mobxTest(
      'initializes list points',
      build: () => MapContainerController(points: points),
      value: (store) => store.listPoints.length,
      act: (store) => store.init(),
      expect: () => [0, 2],
    );

    mobxTest(
      'updates points when list changes',
      build: () => MapContainerController(points: points),
      value: (store) => store.listPoints.length,
      act: (store) {
        store
          ..init()
          ..updatePoints([const Point(latitude: 1, longitude: 1)]);
      },
      expect: () => [0, 2, 1],
    );

    mobxTest(
      'does not update when points are equal',
      build: () => MapContainerController(points: points),
      value: (store) => store.listPoints.length,
      act: (store) {
        store
          ..init()
          ..updatePoints(List.of(points));
      },
      expect: () => [0, 2],
    );
  });
}
