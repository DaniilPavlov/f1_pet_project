import 'package:f1_pet_project/core/results/managers/results_page_manager.dart';
import 'package:f1_pet_project/core/results/providers.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';

void main() {
  group('ResultsPageManager', () {
    ProviderContainer createContainer({
      Future<ScheduleModel> Function()? fetchLastRaceResultsForTest,
      Future<void> Function({bool forceRefresh})? loadScoreboardForTest,
      bool Function()? scoreboardIsValue,
    }) {
      final container = ProviderContainer(
        overrides: [
          resultsPageManagerProvider.overrideWith((ref) {
            final manager = ResultsPageManager(
              holder: ref.watch(resultsPageStateHolderProvider.notifier),
              fetchLastRaceResultsForTest: fetchLastRaceResultsForTest,
              loadScoreboardForTest: loadScoreboardForTest,
              scoreboardIsValue: scoreboardIsValue ?? () => false,
            );
            ref.onDispose(manager.dispose);
            return manager;
          }),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    group('loadLastRaceResults', () {
      test('sets value on success', () async {
        final container = createContainer(fetchLastRaceResultsForTest: () async => ControllerFixtures.scheduleModel);
        final manager = container.read(resultsPageManagerProvider);

        await manager.loadLastRaceResults();

        final state = container.read(resultsPageStateHolderProvider);
        expect(state.lastRace.isValue, isTrue);
        expect(state.lastRace.value?.raceName, 'Monaco Grand Prix');
      });

      test('sets error on failure', () async {
        final container = createContainer(
          fetchLastRaceResultsForTest: () async => throw ResponseParseException('parse error'),
        );
        final manager = container.read(resultsPageManagerProvider);

        await manager.loadLastRaceResults();

        expect(container.read(resultsPageStateHolderProvider).lastRace.isError, isTrue);
      });
    });

    group('loadAllData', () {
      test('loads last race', () async {
        final container = createContainer(fetchLastRaceResultsForTest: () async => ControllerFixtures.scheduleModel);
        final manager = container.read(resultsPageManagerProvider);

        await manager.loadAllData();

        final state = container.read(resultsPageStateHolderProvider);
        expect(state.lastRace.isValue, isTrue);
        expect(state.lastRace.value?.raceName, 'Monaco Grand Prix');
      });
    });

    test('refreshAll reloads last race and live weekend', () async {
      var raceCalls = 0;
      var boardCalls = 0;
      final container = createContainer(
        loadScoreboardForTest: ({bool forceRefresh = false}) async {
          boardCalls++;
        },
        fetchLastRaceResultsForTest: () async {
          raceCalls++;
          return ControllerFixtures.scheduleModel;
        },
      );
      final manager = container.read(resultsPageManagerProvider);

      await manager.refreshAll();

      expect(raceCalls, 1);
      expect(boardCalls, 1);
      expect(container.read(resultsPageStateHolderProvider).lastRace.isValue, isTrue);
    });

    test('screenError mirrors lastRace exception', () async {
      final container = createContainer(
        fetchLastRaceResultsForTest: () async => throw ResponseParseException('parse error'),
      );
      final manager = container.read(resultsPageManagerProvider);

      await manager.loadLastRaceResults();

      expect(container.read(resultsPageStateHolderProvider).screenError, isNotNull);
    });
  });
}
