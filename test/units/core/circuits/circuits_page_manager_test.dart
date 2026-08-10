import 'package:f1_pet_project/core/circuits/managers/circuits_page_manager.dart';
import 'package:f1_pet_project/core/circuits/models/circuits_model.dart';
import 'package:f1_pet_project/core/circuits/providers.dart';
import 'package:f1_pet_project/core/circuits/state/state_models/circuits_page_view_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer buildContainer({
    Future<CircuitsModel> Function()? fetchCircuits,
  }) {
    return ProviderContainer(
      overrides: [
        circuitsPageManagerProvider.overrideWith((ref) {
          final manager = CircuitsPageManager(
            holder: ref.watch(circuitsPageStateHolderProvider.notifier),
            fetchCircuitsForTest: fetchCircuits ?? () async => ControllerFixtures.circuitsModel,
          );
          ref.onDispose(manager.dispose);
          return manager;
        }),
      ],
    );
  }

  group('CircuitsPageManager', () {
    group('loadCircuits', () {
      test('sets success on load', () async {
        final container = buildContainer();
        addTearDown(container.dispose);

        final manager = container.read(circuitsPageManagerProvider);
        final pending = manager.loadCircuits();
        expect(container.read(circuitsPageStateHolderProvider), isA<CircuitsPageLoading>());
        await pending;

        final state = container.read(circuitsPageStateHolderProvider);
        expect(state, isA<CircuitsPageSuccess>());
        expect((state as CircuitsPageSuccess).circuits.first.circuitId, 'monaco');
      });

      test('sets error on failure', () async {
        final container = buildContainer(
          fetchCircuits: () async => throw ResponseParseException('parse error'),
        );
        addTearDown(container.dispose);

        await container.read(circuitsPageManagerProvider).loadCircuits();

        final state = container.read(circuitsPageStateHolderProvider);
        expect(state, isA<CircuitsPageError>());
        expect(state.screenError, isNotNull);
      });
    });

    group('changeActivePage', () {
      test('updates active page', () {
        final container = buildContainer();
        addTearDown(container.dispose);

        final manager = container.read(circuitsPageManagerProvider);
        expect(container.read(circuitsPageStateHolderProvider).activePage, 0);
        manager.changeActivePage(1);
        expect(container.read(circuitsPageStateHolderProvider).activePage, 1);
      });
    });

    test('refreshAll reloads circuits', () async {
      var calls = 0;
      final container = buildContainer(
        fetchCircuits: () async {
          calls++;
          return ControllerFixtures.circuitsModel;
        },
      );
      addTearDown(container.dispose);

      await container.read(circuitsPageManagerProvider).refreshAll();

      expect(calls, 1);
      expect(container.read(circuitsPageStateHolderProvider), isA<CircuitsPageSuccess>());
    });
  });
}
