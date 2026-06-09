import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/results/controllers/results_screen_controller/results_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../mobx/mobx_testing.dart';

void main() {
  group('ResultsScreenController', () {
    group('loadLastRaceResults', () {
      mobxTest(
        'sets value on success',
        build: () => ResultsScreenController(
          fetchLastRaceResults: () async => ControllerFixtures.scheduleModel,
        ),
        value: (store) => store.lastRace,
        act: (store) => store.loadLastRaceResults(),
        expect: () => [
          isA<AsyncValue<RacesModel>>().having(
            (e) => e.status,
            'status',
            AsyncStatus.loading,
          ),
          isA<AsyncValue<RacesModel>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.raceName, 'raceName', 'Monaco Grand Prix'),
        ],
      );

      mobxTest(
        'sets error on failure',
        build: () => ResultsScreenController(
          fetchLastRaceResults: () async => throw ResponseParseException('parse error'),
        ),
        value: (store) => store.lastRace,
        act: (store) => store.loadLastRaceResults(),
        expect: () => [
          isA<AsyncValue<RacesModel>>().having(
            (e) => e.status,
            'status',
            AsyncStatus.loading,
          ),
          isA<AsyncValue<RacesModel>>().having(
            (e) => e.status,
            'status',
            AsyncStatus.error,
          ),
        ],
      );
    });

    group('loadAllData', () {
      test('loads last race', () async {
        final controller = ResultsScreenController(
          fetchLastRaceResults: () async => ControllerFixtures.scheduleModel,
        );

        await controller.loadAllData();

        expect(controller.lastRace.isValue, isTrue);
      });
    });
  });
}
