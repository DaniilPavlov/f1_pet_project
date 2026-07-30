import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/results/controllers/results_screen_controller/results_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../mobx/mobx_testing.dart';

void main() {
  group('ResultsScreenController', () {
    group('loadLastRaceResults', () {
      mobxTest(
        'sets value on success',
        build: () => ResultsScreenController(fetchLastRaceResultsForTest: () async => ControllerFixtures.scheduleModel),
        value: (store) => store.lastRace,
        act: (store) => store.loadLastRaceResults(),
        expect: () => [
          isA<AsyncValue<RacesModel>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<RacesModel>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.raceName, 'raceName', 'Monaco Grand Prix'),
        ],
      );

      mobxTest(
        'sets error on failure',
        build: () =>
            ResultsScreenController(fetchLastRaceResultsForTest: () async => throw ResponseParseException('parse error')),
        value: (store) => store.lastRace,
        act: (store) => store.loadLastRaceResults(),
        expect: () => [
          isA<AsyncValue<RacesModel>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<RacesModel>>().having((e) => e.status, 'status', AsyncStatus.error),
        ],
      );
    });

    group('loadAllData', () {
      test('loads last race', () async {
        final controller = ResultsScreenController(
          fetchLastRaceResultsForTest: () async => ControllerFixtures.scheduleModel,
        );

        await controller.loadAllData();

        expect(controller.lastRace.isValue, isTrue);
        expect(controller.lastRace.value?.raceName, 'Monaco Grand Prix');
      });
    });

    test('refreshAll reloads last race and live weekend', () async {
      var raceCalls = 0;
      var boardCalls = 0;
      final live = LiveWeekendController(
        fetchScoreboardForTest: ({bool forceRefresh = false}) async {
          boardCalls++;
          return null;
        },
      );
      final controller = ResultsScreenController(
        liveWeekend: live,
        fetchLastRaceResultsForTest: () async {
          raceCalls++;
          return ControllerFixtures.scheduleModel;
        },
      );

      await controller.refreshAll();

      expect(raceCalls, 1);
      expect(boardCalls, 1);
      expect(controller.lastRace.isValue, isTrue);
      live.dispose();
    });

    test('screenError mirrors lastRace exception', () async {
      final controller = ResultsScreenController(
        fetchLastRaceResultsForTest: () async => throw ResponseParseException('parse error'),
      );

      await controller.loadLastRaceResults();

      expect(controller.screenError, isNotNull);
    });
  });
}
