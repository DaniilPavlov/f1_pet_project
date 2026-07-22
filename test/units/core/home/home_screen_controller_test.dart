import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/home/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../mobx/mobx_testing.dart';

void main() {
  group('HomeScreenController', () {
    group('loadCurrentDriversStandings', () {
      mobxTest(
        'sets value on success',
        build: () => HomeScreenController(
          fetchCurrentDriversStandingsForTest: () async => ControllerFixtures.driversStandingsModel,
        ),
        value: (store) => store.currentDrivers,
        act: (store) => store.loadCurrentDriversStandings(),
        expect: () => [
          isA<AsyncValue<List<DriverStandingsModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<List<DriverStandingsModel>>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.length, 'length', 1),
        ],
        verify: (store) {
          expect(store.currentSeason, '2024');
          expect(store.currentRound, '5');
        },
      );

      mobxTest(
        'sets error on failure',
        build: () => HomeScreenController(
          fetchCurrentDriversStandingsForTest: () async => throw ResponseParseException('parse error'),
        ),
        value: (store) => store.currentDrivers,
        act: (store) => store.loadCurrentDriversStandings(),
        expect: () => [
          isA<AsyncValue<List<DriverStandingsModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<List<DriverStandingsModel>>>().having((e) => e.status, 'status', AsyncStatus.error),
        ],
        verify: (store) {
          expect(store.screenError, isNotNull);
        },
      );
    });

    group('loadCurrentConstructorsStandings', () {
      mobxTest(
        'sets value on success',
        build: () => HomeScreenController(
          fetchCurrentConstructorsStandingsForTest: () async => ControllerFixtures.constructorsStandingsModel,
        ),
        value: (store) => store.currentConstructors,
        act: (store) => store.loadCurrentConstructorsStandings(),
        expect: () => [
          isA<AsyncValue<List<ConstructorStandingsModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<List<ConstructorStandingsModel>>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.length, 'length', 1),
        ],
      );
    });

    group('loadAllData', () {
      test('loads drivers and constructors standings', () async {
        final controller = HomeScreenController(
          fetchCurrentDriversStandingsForTest: () async => ControllerFixtures.driversStandingsModel,
          fetchCurrentConstructorsStandingsForTest: () async => ControllerFixtures.constructorsStandingsModel,
        );

        await controller.loadAllData();

        expect(controller.currentDrivers.isValue, isTrue);
        expect(controller.currentConstructors.isValue, isTrue);
      });
    });
  });
}
