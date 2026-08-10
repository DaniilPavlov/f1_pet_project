import 'package:f1_pet_project/core/results/models/pit_stops_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/race_info/managers/race_info_page_manager.dart';
import 'package:f1_pet_project/core/results/race_info/providers.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../helpers/fake_repositories.dart';
import '../../../helpers/widget_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final race = ControllerFixtures.race;

  ProviderContainer buildContainer({
    RacesModel? raceModel,
    FakeScheduleRepository? scheduleRepository,
    Future<bool> Function()? weekendHasSprintForTest,
    Future<ScheduleModel> Function({required String year, required String round})? fetchQualifyingResultsForTest,
    Future<ScheduleModel> Function({required String year, required String round})? fetchPitStopsForTest,
    Future<ScheduleModel> Function({required String year, required String round})? fetchSprintResultsForTest,
  }) {
    final model = raceModel ?? race;
    final container = ProviderContainer(
      overrides: [
        raceInfoPageManagerProvider(model).overrideWith((ref) {
          final manager = RaceInfoPageManager(
            raceModel: model,
            holder: ref.watch(raceInfoPageStateHolderProvider(model).notifier),
            scheduleRepository: scheduleRepository,
            weekendHasSprintForTest: weekendHasSprintForTest,
            fetchPitStopsForTest: fetchPitStopsForTest,
            fetchQualifyingResultsForTest: fetchQualifyingResultsForTest,
            fetchSprintResultsForTest: fetchSprintResultsForTest,
          );
          ref.onDispose(manager.dispose);
          return manager;
        }),
      ],
    )..listen(raceInfoPageStateHolderProvider(model), (_, _) {})
      ..listen(raceInfoPageManagerProvider(model), (_, _) {});
    return container;
  }

  group('RaceInfoPageManager', () {
    group('loadQualifyingResults', () {
      test('sets value on success', () async {
        final container = buildContainer(
          fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        );
        addTearDown(container.dispose);

        await container.read(raceInfoPageManagerProvider(race)).loadQualifyingResults();

        final state = container.read(raceInfoPageStateHolderProvider(race));
        expect(state.qualifyingResults.isValue, isTrue);
        expect(state.qualifyingResults.value, hasLength(1));
      });

      test('sets error on failure', () async {
        final container = buildContainer(
          fetchQualifyingResultsForTest: ({required year, required round}) async =>
              throw ResponseParseException('parse error'),
        );
        addTearDown(container.dispose);

        await container.read(raceInfoPageManagerProvider(race)).loadQualifyingResults();

        final state = container.read(raceInfoPageStateHolderProvider(race));
        expect(state.qualifyingResults.isError, isTrue);
        expect(state.screenError, isNotNull);
      });
    });

    group('loadPitStops', () {
      test('resolves driver names from race results without extra API calls', () async {
        final container = buildContainer(
          fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        );
        addTearDown(container.dispose);

        await container.read(raceInfoPageManagerProvider(race)).loadPitStops();

        final state = container.read(raceInfoPageStateHolderProvider(race));
        expect(state.pitStops.isValue, isTrue);
        expect(state.pitStops.value?.single.driverId, 'Max Verstappen');
      });
    });

    group('loadAllData', () {
      test('marks data as loaded', () async {
        final container = buildContainer(
          weekendHasSprintForTest: () async => false,
          fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
          fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
          fetchSprintResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        );
        addTearDown(container.dispose);

        await container.read(raceInfoPageManagerProvider(race)).loadAllData();

        expect(container.read(raceInfoPageStateHolderProvider(race)).allDataIsLoaded, isTrue);
      });
    });

    group('loadSprintResults', () {
      test('sets empty list when weekend has no sprint', () async {
        final container = buildContainer(
          fetchSprintResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        );
        addTearDown(container.dispose);

        await container.read(raceInfoPageManagerProvider(race)).loadSprintResults();

        final state = container.read(raceInfoPageStateHolderProvider(race));
        expect(state.sprintResults.isValue, isTrue);
        expect(state.sprintResults.value, isEmpty);
      });
    });

    test('loadAllData loads sprint when weekendHasSprint is true', () async {
      var sprintCalls = 0;
      final container = buildContainer(
        weekendHasSprintForTest: () async => true,
        fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        fetchSprintResultsForTest: ({required year, required round}) async {
          sprintCalls++;
          return ControllerFixtures.scheduleModel;
        },
      );
      addTearDown(container.dispose);

      await container.read(raceInfoPageManagerProvider(race)).loadAllData();

      expect(sprintCalls, 1);
      expect(container.read(raceInfoPageStateHolderProvider(race)).allDataIsLoaded, isTrue);
      expect(container.read(raceInfoPageStateHolderProvider(race)).hasSprintResults, isFalse);
    });

    test('loadAllData skips sprint fetch when raceModel.sprint is null and hook says false', () async {
      var sprintCalls = 0;
      final container = buildContainer(
        weekendHasSprintForTest: () async => false,
        fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        fetchSprintResultsForTest: ({required year, required round}) async {
          sprintCalls++;
          return ControllerFixtures.scheduleModel;
        },
      );
      addTearDown(container.dispose);

      await container.read(raceInfoPageManagerProvider(race)).loadAllData();

      expect(sprintCalls, 0);
      expect(container.read(raceInfoPageStateHolderProvider(race)).sprintResults.value, isEmpty);
    });

    test('refreshAll reloads sections', () async {
      var calls = 0;
      final container = buildContainer(
        weekendHasSprintForTest: () async => false,
        fetchQualifyingResultsForTest: ({required year, required round}) async {
          calls++;
          return ControllerFixtures.scheduleModel;
        },
        fetchPitStopsForTest: ({required year, required round}) async {
          calls++;
          return ControllerFixtures.scheduleModel;
        },
      );
      addTearDown(container.dispose);

      await container.read(raceInfoPageManagerProvider(race)).refreshAll();

      expect(calls, 2);
      expect(container.read(raceInfoPageStateHolderProvider(race)).qualifyingResults.isValue, isTrue);
    });

    test('empty race tables yield empty lists', () async {
      final container = buildContainer(
        fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
      );
      addTearDown(container.dispose);

      final manager = container.read(raceInfoPageManagerProvider(race));
      await manager.loadQualifyingResults();
      await manager.loadPitStops();

      final state = container.read(raceInfoPageStateHolderProvider(race));
      expect(state.qualifyingResults.value, isEmpty);
      expect(state.pitStops.value, isEmpty);
    });

    test('weekendHasSprint uses scheduleRepository when present', () async {
      final raceWithoutSprint = RacesModel(
        season: '2024',
        round: '5',
        url: 'http://example.com',
        raceName: 'Monaco Grand Prix',
        circuit: ControllerFixtures.circuit,
        date: '2024-05-26',
        time: '13:00:00Z',
        firstPractice: null,
        secondPractice: null,
        thirdPractice: null,
        qualifying: null,
        sprint: null,
        results: null,
        qualifyingResults: null,
        pitStops: null,
      );
      final scheduled = RacesModel(
        season: '2024',
        round: '5',
        url: 'http://example.com',
        raceName: 'Monaco Grand Prix',
        circuit: ControllerFixtures.circuit,
        date: '2024-05-26',
        time: '13:00:00Z',
        firstPractice: null,
        secondPractice: null,
        thirdPractice: null,
        qualifying: null,
        sprint: RaceDateModel(date: '2024-05-25', time: '16:00:00Z'),
        results: null,
        qualifyingResults: null,
        pitStops: null,
      );

      var sprintCalls = 0;
      final container = buildContainer(
        raceModel: raceWithoutSprint,
        scheduleRepository: FakeScheduleRepository(
          result: ScheduleLoadResult(
            schedule: ScheduleModel(
              raceTable: RaceTableModel(season: '2024', round: '5', races: [scheduled]),
            ),
            fetchedFromNetwork: false,
          ),
        ),
        fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchSprintResultsForTest: ({required year, required round}) async {
          sprintCalls++;
          return ControllerFixtures.emptyScheduleModel;
        },
      );
      addTearDown(container.dispose);

      await container.read(raceInfoPageManagerProvider(raceWithoutSprint)).loadAllData();
      expect(sprintCalls, 1);
      expect(container.read(raceInfoPageStateHolderProvider(raceWithoutSprint)).allDataIsLoaded, isTrue);
    });

    test('weekendHasSprint defaults true when schedule misses race or throws', () async {
      var sprintCalls = 0;
      final miss = buildContainer(
        scheduleRepository: FakeScheduleRepository(
          result: ScheduleLoadResult(schedule: ControllerFixtures.emptyScheduleModel, fetchedFromNetwork: false),
        ),
        fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchSprintResultsForTest: ({required year, required round}) async {
          sprintCalls++;
          return ControllerFixtures.emptyScheduleModel;
        },
      );
      addTearDown(miss.dispose);
      await miss.read(raceInfoPageManagerProvider(race)).loadAllData();
      expect(sprintCalls, 1);

      sprintCalls = 0;
      final boom = buildContainer(
        scheduleRepository: FakeScheduleRepository(
          result: ScheduleLoadResult(schedule: ControllerFixtures.emptyScheduleModel, fetchedFromNetwork: false),
          throwOnLoad: true,
        ),
        fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchSprintResultsForTest: ({required year, required round}) async {
          sprintCalls++;
          return ControllerFixtures.emptyScheduleModel;
        },
      );
      addTearDown(boom.dispose);
      await boom.read(raceInfoPageManagerProvider(race)).loadAllData();
      expect(sprintCalls, 1);
    });

    test('pit stop names fall back to sprint results', () async {
      final sprintOnlyDriver = ResultsModel(
        number: '4',
        position: '1',
        positionText: '1',
        points: '8',
        driver: WidgetFixtures.norris,
        constructor: WidgetFixtures.ferrari,
        grid: '1',
        laps: '18',
        status: 'Finished',
        time: null,
        fastestLap: null,
      );
      final raceWithSprint = RacesModel(
        season: '2024',
        round: '5',
        url: 'http://example.com',
        raceName: 'Monaco',
        circuit: ControllerFixtures.circuit,
        date: '2024-05-26',
        time: '13:00:00Z',
        firstPractice: null,
        secondPractice: null,
        thirdPractice: null,
        qualifying: null,
        sprint: RaceDateModel(date: '2024-05-25', time: '16:00:00Z'),
        results: const [],
        qualifyingResults: const [],
        pitStops: null,
      );

      final container = buildContainer(
        raceModel: raceWithSprint,
        fetchSprintResultsForTest: ({required year, required round}) async => ScheduleModel(
          raceTable: RaceTableModel(
            season: '2024',
            round: '5',
            races: [
              RacesModel(
                season: '2024',
                round: '5',
                url: 'http://example.com',
                raceName: 'Monaco',
                circuit: ControllerFixtures.circuit,
                date: '2024-05-26',
                time: '13:00:00Z',
                firstPractice: null,
                secondPractice: null,
                thirdPractice: null,
                qualifying: null,
                sprint: null,
                results: null,
                qualifyingResults: null,
                pitStops: null,
                sprintResults: [sprintOnlyDriver],
              ),
            ],
          ),
        ),
        fetchPitStopsForTest: ({required year, required round}) async => ScheduleModel(
          raceTable: RaceTableModel(
            season: '2024',
            round: '5',
            races: [
              RacesModel(
                season: '2024',
                round: '5',
                url: 'http://example.com',
                raceName: 'Monaco',
                circuit: ControllerFixtures.circuit,
                date: '2024-05-26',
                time: '13:00:00Z',
                firstPractice: null,
                secondPractice: null,
                thirdPractice: null,
                qualifying: null,
                sprint: null,
                results: null,
                qualifyingResults: null,
                pitStops: [PitStopsModel(driverId: 'norris', lap: '5', stop: '1', time: '14:00:00', duration: '2.3')],
              ),
            ],
          ),
        ),
      );
      addTearDown(container.dispose);

      final manager = container.read(raceInfoPageManagerProvider(raceWithSprint));
      await manager.loadSprintResults();
      await manager.loadPitStops();
      expect(container.read(raceInfoPageStateHolderProvider(raceWithSprint)).pitStops.value?.single.driverId, 'Lando Norris');
    });
  });
}
