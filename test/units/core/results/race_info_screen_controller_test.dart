import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/results/models/pit_stops_model.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/race_info/controllers/race_info_screen_controller/race_info_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../helpers/fake_repositories.dart';
import '../../../helpers/widget_fixtures.dart';
import '../../../mobx/mobx_testing.dart';

void main() {
  group('RaceInfoScreenController', () {
    group('loadQualifyingResults', () {
      mobxTest(
        'sets value on success',
        build: () => RaceInfoScreenController(
          raceModel: ControllerFixtures.race,
          fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        ),
        value: (store) => store.qualifyingResults,
        act: (store) => store.loadQualifyingResults(),
        expect: () => [
          isA<AsyncValue<List<QualifyingResultsModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<List<QualifyingResultsModel>>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.length, 'length', 1),
        ],
      );

      mobxTest(
        'sets error on failure',
        build: () => RaceInfoScreenController(
          raceModel: ControllerFixtures.race,
          fetchQualifyingResultsForTest: ({required year, required round}) async =>
              throw ResponseParseException('parse error'),
        ),
        value: (store) => store.qualifyingResults,
        act: (store) => store.loadQualifyingResults(),
        expect: () => [
          isA<AsyncValue<List<QualifyingResultsModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<List<QualifyingResultsModel>>>().having((e) => e.status, 'status', AsyncStatus.error),
        ],
        verify: (store) {
          expect(store.screenError, isNotNull);
        },
      );
    });

    group('loadPitStops', () {
      mobxTest(
        'resolves driver names from race results without extra API calls',
        build: () => RaceInfoScreenController(
          raceModel: ControllerFixtures.race,
          fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        ),
        value: (store) => store.pitStops,
        act: (store) => store.loadPitStops(),
        expect: () => [
          isA<AsyncValue<List<PitStopsModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<List<PitStopsModel>>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.single.driverId, 'driverId', 'Max Verstappen'),
        ],
      );
    });

    group('loadAllData', () {
      mobxTest(
        'marks data as loaded',
        build: () => RaceInfoScreenController(
          raceModel: ControllerFixtures.race,
          weekendHasSprintForTest: () async => false,
          fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
          fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
          fetchSprintResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        ),
        value: (store) => store.allDataIsLoaded,
        act: (store) => store.loadAllData(),
        expect: () => [false, true],
      );
    });

    group('loadSprintResults', () {
      mobxTest(
        'sets empty list when weekend has no sprint',
        build: () => RaceInfoScreenController(
          raceModel: ControllerFixtures.race,
          fetchSprintResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        ),
        value: (store) => store.sprintResults,
        act: (store) => store.loadSprintResults(),
        expect: () => [
          isA<AsyncValue<List<ResultsModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<List<ResultsModel>>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value, 'value', isEmpty),
        ],
      );
    });

    test('loadAllData loads sprint when weekendHasSprint is true', () async {
      var sprintCalls = 0;
      final controller = RaceInfoScreenController(
        raceModel: ControllerFixtures.race,
        weekendHasSprintForTest: () async => true,
        fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        fetchSprintResultsForTest: ({required year, required round}) async {
          sprintCalls++;
          return ControllerFixtures.scheduleModel;
        },
      );

      await controller.loadAllData();

      expect(sprintCalls, 1);
      expect(controller.allDataIsLoaded, isTrue);
      expect(controller.hasSprintResults, isFalse); // fixture has no sprintResults
    });

    test('loadAllData skips sprint fetch when raceModel.sprint is null and hook says false', () async {
      var sprintCalls = 0;
      final controller = RaceInfoScreenController(
        raceModel: ControllerFixtures.race,
        weekendHasSprintForTest: () async => false,
        fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        fetchSprintResultsForTest: ({required year, required round}) async {
          sprintCalls++;
          return ControllerFixtures.scheduleModel;
        },
      );

      await controller.loadAllData();

      expect(sprintCalls, 0);
      expect(controller.sprintResults.value, isEmpty);
    });

    test('refreshAll reloads sections', () async {
      var calls = 0;
      final controller = RaceInfoScreenController(
        raceModel: ControllerFixtures.race,
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

      await controller.refreshAll();

      expect(calls, 2);
      expect(controller.qualifyingResults.isValue, isTrue);
    });

    test('empty race tables yield empty lists', () async {
      final controller = RaceInfoScreenController(
        raceModel: ControllerFixtures.race,
        fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
      );

      await controller.loadQualifyingResults();
      await controller.loadPitStops();

      expect(controller.qualifyingResults.value, isEmpty);
      expect(controller.pitStops.value, isEmpty);
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
      final controller = RaceInfoScreenController(
        raceModel: raceWithoutSprint,
        scheduleRepository: FakeScheduleRepository(
          result:           ScheduleLoadResult(
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

      await controller.loadAllData();
      expect(sprintCalls, 1);
    });

    test('weekendHasSprint defaults true when schedule misses race or throws', () async {
      final race = ControllerFixtures.race; // sprint null
      var sprintCalls = 0;
      final miss = RaceInfoScreenController(
        raceModel: race,
        scheduleRepository: FakeScheduleRepository(
          result:           ScheduleLoadResult(
            schedule: ControllerFixtures.emptyScheduleModel,
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
      await miss.loadAllData();
      expect(sprintCalls, 1);

      sprintCalls = 0;
      final boom = RaceInfoScreenController(
        raceModel: race,
        scheduleRepository: FakeScheduleRepository(
          result:           ScheduleLoadResult(
            schedule: ControllerFixtures.emptyScheduleModel,
            fetchedFromNetwork: false,
          ),
          throwOnLoad: true,
        ),
        fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchSprintResultsForTest: ({required year, required round}) async {
          sprintCalls++;
          return ControllerFixtures.emptyScheduleModel;
        },
      );
      await boom.loadAllData();
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
      final race = RacesModel(
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

      final controller = RaceInfoScreenController(
        raceModel: race,
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
                pitStops: [
                  PitStopsModel(driverId: 'norris', lap: '5', stop: '1', time: '14:00:00', duration: '2.3'),
                ],
              ),
            ],
          ),
        ),
      );

      await controller.loadSprintResults();
      await controller.loadPitStops();
      expect(controller.pitStops.value?.single.driverId, 'Lando Norris');
    });
  });
}
