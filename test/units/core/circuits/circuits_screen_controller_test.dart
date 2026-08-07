import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/circuits/controllers/circuits_screen_controller/circuits_screen_controller.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CircuitsScreenController', () {
    group('loadCircuits', () {
      test('sets value on success', () async {
        final container = ProviderContainer(
          overrides: [
            circuitsScreenControllerProvider.overrideWith(
              () => CircuitsScreenController(fetchCircuitsForTest: () async => ControllerFixtures.circuitsModel),
            ),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(circuitsScreenControllerProvider.notifier);
        final pending = controller.loadCircuits();
        expect(container.read(circuitsScreenControllerProvider).circuits.status, LoadableStatus.loading);
        await pending;

        final state = container.read(circuitsScreenControllerProvider);
        expect(state.circuits.status, LoadableStatus.value);
        expect(state.circuits.value?.first.circuitId, 'monaco');
      });

      test('sets error on failure', () async {
        final container = ProviderContainer(
          overrides: [
            circuitsScreenControllerProvider.overrideWith(
              () => CircuitsScreenController(
                fetchCircuitsForTest: () async => throw ResponseParseException('parse error'),
              ),
            ),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(circuitsScreenControllerProvider.notifier);
        await controller.loadCircuits();

        final state = container.read(circuitsScreenControllerProvider);
        expect(state.circuits.status, LoadableStatus.error);
        expect(state.screenError, isNotNull);
      });
    });

    group('changeActivePage', () {
      test('updates active page', () {
        final container = ProviderContainer(
          overrides: [
            circuitsScreenControllerProvider.overrideWith(CircuitsScreenController.new),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(circuitsScreenControllerProvider.notifier);
        expect(container.read(circuitsScreenControllerProvider).activePage, 0);
        controller.changeActivePage(1);
        expect(container.read(circuitsScreenControllerProvider).activePage, 1);
      });
    });

    test('refreshAll reloads circuits', () async {
      var calls = 0;
      final container = ProviderContainer(
        overrides: [
          circuitsScreenControllerProvider.overrideWith(
            () => CircuitsScreenController(
              fetchCircuitsForTest: () async {
                calls++;
                return ControllerFixtures.circuitsModel;
              },
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(circuitsScreenControllerProvider.notifier).refreshAll();

      expect(calls, 1);
      expect(container.read(circuitsScreenControllerProvider).circuits.isValue, isTrue);
    });
  });
}
