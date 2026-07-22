import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/circuits/controllers/circuits_screen_controller/circuits_screen_controller.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../mobx/mobx_testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CircuitsScreenController', () {
    group('loadCircuits', () {
      mobxTest(
        'sets value on success',
        build: () => CircuitsScreenController(fetchCircuitsForTest: () async => ControllerFixtures.circuitsModel),
        value: (store) => store.circuits,
        act: (store) => store.loadCircuits(),
        expect: () => [
          isA<AsyncValue<List<CircuitModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<List<CircuitModel>>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.first.circuitId, 'circuitId', 'monaco'),
        ],
      );

      mobxTest(
        'sets error on failure',
        build: () => CircuitsScreenController(fetchCircuitsForTest: () async => throw ResponseParseException('parse error')),
        value: (store) => store.circuits,
        act: (store) => store.loadCircuits(),
        expect: () => [
          isA<AsyncValue<List<CircuitModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<List<CircuitModel>>>().having((e) => e.status, 'status', AsyncStatus.error),
        ],
        verify: (store) {
          expect(store.screenError, isNotNull);
        },
      );
    });

    group('changeActivePage', () {
      mobxTest(
        'updates active page',
        build: CircuitsScreenController.new,
        value: (store) => store.activePage,
        act: (store) => store.changeActivePage(1),
        expect: () => [0, 1],
      );
    });
  });
}
