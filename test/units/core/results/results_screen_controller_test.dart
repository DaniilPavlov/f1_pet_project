import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/core/results/controllers/results_screen_controller/results_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../helpers/riverpod_container.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  (ResultsScreenController, ProviderContainer) createController({
    Future<ScheduleModel> Function()? fetchLastRaceResultsForTest,
    Future<EspnScoreboardEvent?> Function({bool forceRefresh})? fetchScoreboardForTest,
  }) {
    late ResultsScreenController controller;
    final container =
        createNotifierContainer(
            overrides: [
              liveWeekendControllerProvider.overrideWith(
                () => LiveWeekendController(
                  fetchScoreboardForTest: fetchScoreboardForTest ?? ({bool forceRefresh = false}) async => null,
                ),
              ),
              resultsScreenControllerProvider.overrideWith(
                () => controller = ResultsScreenController(fetchLastRaceResultsForTest: fetchLastRaceResultsForTest),
              ),
            ],
          )
          ..listen(liveWeekendControllerProvider, (_, _) {})
          ..listen(resultsScreenControllerProvider, (_, _) {});
    controller = container.read(resultsScreenControllerProvider.notifier);
    return (controller, container);
  }

  group('ResultsScreenController', () {
    group('loadLastRaceResults', () {
      test('sets value on success', () async {
        final (controller, container) = createController(
          fetchLastRaceResultsForTest: () async => ControllerFixtures.scheduleModel,
        );

        await controller.loadLastRaceResults();

        final state = container.read(resultsScreenControllerProvider);
        expect(state.lastRace.isValue, isTrue);
        expect(state.lastRace.value?.raceName, 'Monaco Grand Prix');
      });

      test('sets error on failure', () async {
        final (controller, container) = createController(
          fetchLastRaceResultsForTest: () async => throw ResponseParseException('parse error'),
        );

        await controller.loadLastRaceResults();

        expect(container.read(resultsScreenControllerProvider).lastRace.isError, isTrue);
      });
    });

    group('loadAllData', () {
      test('loads last race', () async {
        final (controller, container) = createController(
          fetchLastRaceResultsForTest: () async => ControllerFixtures.scheduleModel,
        );

        await controller.loadAllData();

        final state = container.read(resultsScreenControllerProvider);
        expect(state.lastRace.isValue, isTrue);
        expect(state.lastRace.value?.raceName, 'Monaco Grand Prix');
      });
    });

    test('refreshAll reloads last race and live weekend', () async {
      var raceCalls = 0;
      var boardCalls = 0;
      final (controller, container) = createController(
        fetchScoreboardForTest: ({bool forceRefresh = false}) async {
          boardCalls++;
          return null;
        },
        fetchLastRaceResultsForTest: () async {
          raceCalls++;
          return ControllerFixtures.scheduleModel;
        },
      );

      await controller.refreshAll();

      expect(raceCalls, 1);
      expect(boardCalls, 1);
      expect(container.read(resultsScreenControllerProvider).lastRace.isValue, isTrue);
    });

    test('screenError mirrors lastRace exception', () async {
      final (controller, container) = createController(
        fetchLastRaceResultsForTest: () async => throw ResponseParseException('parse error'),
      );

      await controller.loadLastRaceResults();

      expect(container.read(resultsScreenControllerProvider).screenError, isNotNull);
    });
  });
}
