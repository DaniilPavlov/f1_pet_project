import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../mobx/mobx_testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RaceSearchScreenController', () {
    group('checkFields', () {
      mobxTest(
        'marks fields as invalid when empty',
        build: RaceSearchScreenController.new,
        value: (store) => store.fieldsInputted,
        act: (store) => store.checkFields(),
        expect: () => [false],
      );

      mobxTest(
        'marks fields as valid when year and round are filled',
        build: RaceSearchScreenController.new,
        value: (store) => store.fieldsInputted,
        act: (store) {
          store.yearController.text = '2024';
          store.roundController.text = '5';
          store.checkFields();
        },
        expect: () => [false, true],
      );
    });

    group('loadRaceResults', () {
      mobxTest(
        'sets value on success',
        build: () => RaceSearchScreenController(
          fetchRaceResults: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        ),
        value: (store) => store.searchedRace,
        act: (store) async {
          store.yearController.text = '2024';
          store.roundController.text = '5';
          await store.loadRaceResults();
        },
        expect: () => [
          isA<AsyncValue<RacesModel?>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value, 'value', isNull),
          isA<AsyncValue<RacesModel?>>().having(
            (e) => e.status,
            'status',
            AsyncStatus.loading,
          ),
          isA<AsyncValue<RacesModel?>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.raceName, 'raceName', 'Monaco Grand Prix'),
        ],
        verify: (store) {
          expect(store.dataIsLoaded, isTrue);
          expect(store.errorMessage, isEmpty);
        },
      );

      mobxTest(
        'sets message when race is not found',
        build: () => RaceSearchScreenController(
          fetchRaceResults: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        ),
        value: (store) => store.errorMessage,
        act: (store) async {
          store.yearController.text = '2024';
          store.roundController.text = '99';
          await store.loadRaceResults();
        },
        expect: () => [
          '',
          'По вашему запросу гонок не найдено. Проверьте введенные данные и попробуйте еще раз.',
        ],
      );

      mobxTest(
        'sets error on failure',
        build: () => RaceSearchScreenController(
          fetchRaceResults: ({required year, required round}) async => throw ResponseParseException('parse error'),
        ),
        value: (store) => store.searchedRace,
        act: (store) async {
          store.yearController.text = '2024';
          store.roundController.text = '5';
          await store.loadRaceResults();
        },
        expect: () => [
          isA<AsyncValue<RacesModel?>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value, 'value', isNull),
          isA<AsyncValue<RacesModel?>>().having(
            (e) => e.status,
            'status',
            AsyncStatus.loading,
          ),
          isA<AsyncValue<RacesModel?>>().having(
            (e) => e.status,
            'status',
            AsyncStatus.error,
          ),
        ],
      );
    });
  });
}
