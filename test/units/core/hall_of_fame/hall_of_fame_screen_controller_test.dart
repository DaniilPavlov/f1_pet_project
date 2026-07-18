import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/hall_of_fame/controllers/hall_of_fame_screen_controller/hall_of_fame_screen_controller.dart';
import 'package:f1_pet_project/core/home/models/standings/standings_lists_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../mobx/mobx_testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HallOfFameScreenController', () {
    group('checkFields', () {
      mobxTest(
        'marks fields as valid for 4-digit year',
        build: HallOfFameScreenController.new,
        value: (store) => store.fieldsInputted,
        act: (store) => store.checkFields(),
        expect: () => [true],
      );

      mobxTest(
        'marks fields as invalid for short year',
        build: HallOfFameScreenController.new,
        value: (store) => store.fieldsInputted,
        act: (store) {
          store.yearController.text = '20';
          store.checkFields();
        },
        expect: () => [true, false],
      );
    });

    group('loadDriversStandings', () {
      mobxTest(
        'sets value on success',
        build: () =>
            HallOfFameScreenController(fetchDriversStandings: (_) async => ControllerFixtures.driversStandingsModel),
        value: (store) => store.driversStandings,
        act: (store) => store.loadDriversStandings(year: '2024'),
        expect: () => [
          isA<AsyncValue<List<StandingsListsModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<List<StandingsListsModel>>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.length, 'length', 1),
        ],
      );
    });

    group('loadAllData', () {
      test('loads standings for selected year', () async {
        final controller = HallOfFameScreenController(
          fetchDriversStandings: (_) async => ControllerFixtures.driversStandingsModel,
          fetchConstructorsStandings: (_) async => ControllerFixtures.constructorsStandingsModel,
        );

        await controller.loadAllData();

        expect(controller.driversStandings.isValue, isTrue);
        expect(controller.constructorsStandings.isValue, isTrue);
      });
    });
  });
}
