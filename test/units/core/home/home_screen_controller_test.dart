import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/home/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';

void main() {
  group('HomeScreenController', () {
    ProviderContainer createContainer({
      Future<StandingsModel> Function()? fetchDrivers,
      Future<StandingsModel> Function()? fetchConstructors,
    }) {
      final container = ProviderContainer(
        overrides: [
          homeScreenControllerProvider.overrideWith(
            () => HomeScreenController(
              fetchCurrentDriversStandingsForTest: fetchDrivers,
              fetchCurrentConstructorsStandingsForTest: fetchConstructors,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    group('loadCurrentDriversStandings', () {
      test('sets value on success', () async {
        final container = createContainer(
          fetchDrivers: () async => ControllerFixtures.driversStandingsModel,
        );
        final controller = container.read(homeScreenControllerProvider.notifier);

        await controller.loadCurrentDriversStandings();

        final state = container.read(homeScreenControllerProvider);
        expect(state.currentDrivers.status, LoadableStatus.value);
        expect(state.currentDrivers.value, hasLength(1));
        expect(state.currentSeason, '2024');
        expect(state.currentRound, '5');
      });

      test('sets error on failure', () async {
        final container = createContainer(
          fetchDrivers: () async => throw ResponseParseException('parse error'),
        );
        final controller = container.read(homeScreenControllerProvider.notifier);

        await controller.loadCurrentDriversStandings();

        final state = container.read(homeScreenControllerProvider);
        expect(state.currentDrivers.status, LoadableStatus.error);
        expect(state.screenError, isNotNull);
      });
    });

    group('loadCurrentConstructorsStandings', () {
      test('sets value on success', () async {
        final container = createContainer(
          fetchConstructors: () async => ControllerFixtures.constructorsStandingsModel,
        );
        final controller = container.read(homeScreenControllerProvider.notifier);

        await controller.loadCurrentConstructorsStandings();

        final state = container.read(homeScreenControllerProvider);
        expect(state.currentConstructors.status, LoadableStatus.value);
        expect(state.currentConstructors.value, hasLength(1));
      });
    });

    group('loadAllData', () {
      test('loads drivers and constructors standings', () async {
        final container = createContainer(
          fetchDrivers: () async => ControllerFixtures.driversStandingsModel,
          fetchConstructors: () async => ControllerFixtures.constructorsStandingsModel,
        );
        final controller = container.read(homeScreenControllerProvider.notifier);

        await controller.loadAllData();

        final state = container.read(homeScreenControllerProvider);
        expect(state.currentDrivers.isValue, isTrue);
        expect(state.currentConstructors.isValue, isTrue);
      });
    });

    test('refreshAll reloads both tables', () async {
      var calls = 0;
      final container = createContainer(
        fetchDrivers: () async {
          calls++;
          return ControllerFixtures.driversStandingsModel;
        },
        fetchConstructors: () async {
          calls++;
          return ControllerFixtures.constructorsStandingsModel;
        },
      );
      final controller = container.read(homeScreenControllerProvider.notifier);

      await controller.refreshAll();

      final state = container.read(homeScreenControllerProvider);
      expect(calls, 2);
      expect(state.currentDrivers.isValue, isTrue);
      expect(state.currentConstructors.isValue, isTrue);
    });
  });
}
