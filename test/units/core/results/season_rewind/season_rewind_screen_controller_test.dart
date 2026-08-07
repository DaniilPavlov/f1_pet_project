import 'package:f1_pet_project/core/results/season_rewind/controllers/season_rewind_screen_controller/season_rewind_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_table_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/riverpod_container.dart';

RacesModel _race({required String round, required String name, required String date}) {
  final base = ControllerFixtures.race;
  return RacesModel(
    season: base.season,
    round: round,
    url: base.url,
    raceName: name,
    circuit: base.circuit,
    date: date,
    time: base.time,
    firstPractice: null,
    secondPractice: null,
    thirdPractice: null,
    qualifying: null,
    sprint: null,
    results: const [],
    qualifyingResults: const [],
    pitStops: const [],
  );
}

List<RacesModel> get _threeRaces => [
  _race(round: '1', name: 'Bahrain Grand Prix', date: '2024-03-02'),
  _race(round: '2', name: 'Saudi Arabian Grand Prix', date: '2024-03-09'),
  _race(round: '3', name: 'Australian Grand Prix', date: '2024-03-24'),
];

StandingsModel _standingsDrivers({required String round, String points = '100'}) => StandingsModel(
  standingsTable: StandingsTableModel(
    standingsLists: [
      StandingsListsModel(
        season: '2024',
        round: round,
        driverStandings: [
          DriverStandingsModel(
            position: '1',
            positionText: '1',
            points: points,
            wins: '1',
            driver: ControllerFixtures.driver,
            constructors: [ControllerFixtures.constructor],
          ),
        ],
        constructorStandings: null,
      ),
    ],
  ),
);

StandingsModel _standingsConstructors({required String round, String points = '200'}) => StandingsModel(
  standingsTable: StandingsTableModel(
    standingsLists: [
      StandingsListsModel(
        season: '2024',
        round: round,
        driverStandings: null,
        constructorStandings: [
          ConstructorStandingsModel(
            position: '1',
            positionText: '1',
            points: points,
            wins: '1',
            constructor: ControllerFixtures.constructor,
          ),
        ],
      ),
    ],
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  (SeasonRewindScreenController, ProviderContainer) createController({
    FakeSeasonsRepository? seasonsRepository,
    Future<List<RacesModel>> Function(String year)? fetchSeasonRacesForTest,
    Future<StandingsModel> Function(String year, String round)? fetchDriversStandingsForTest,
    Future<StandingsModel> Function(String year, String round)? fetchConstructorsStandingsForTest,
    Duration playInterval = const Duration(milliseconds: 1500),
  }) {
    late SeasonRewindScreenController controller;
    final container = createNotifierContainer(
      overrides: [
        seasonRewindScreenControllerProvider.overrideWith(
          () => controller = SeasonRewindScreenController(
            seasonsRepositoryForTest: seasonsRepository,
            fetchSeasonRacesForTest: fetchSeasonRacesForTest,
            fetchDriversStandingsForTest: fetchDriversStandingsForTest,
            fetchConstructorsStandingsForTest: fetchConstructorsStandingsForTest,
            playInterval: playInterval,
          ),
        ),
      ],
    )..listen(seasonRewindScreenControllerProvider, (_, _) {});
    controller = container.read(seasonRewindScreenControllerProvider.notifier);
    return (controller, container);
  }

  group('SeasonRewindScreenController', () {
    test('completedRacesAsOf drops future rounds', () {
      final races = [
        _race(round: '1', name: 'A', date: '2024-03-01'),
        _race(round: '2', name: 'B', date: '2024-03-15'),
        _race(round: '3', name: 'C', date: '2099-12-01'),
      ];

      final completed = SeasonRewindScreenController.completedRacesAsOf(races, DateTime.utc(2024, 3, 15));

      expect(completed.map((r) => r.round), ['1', '2']);
    });

    test('bootstrap sets year, races and standings', () async {
      final (controller, container) = createController(
        seasonsRepository: FakeSeasonsRepository(years: ['2024', '2023']),
        fetchSeasonRacesForTest: (_) async => _threeRaces,
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
      );

      await controller.bootstrap();

      expect(controller.yearController.text, '2024');
      final state = container.read(seasonRewindScreenControllerProvider);
      expect(state.races.value?.length, 3);
      expect(state.selectedRoundIndex, 2);
      expect(state.selectedRace?.raceName, 'Australian Grand Prix');
      expect(state.chartRound, '3');
      expect(state.hasChartData, isTrue);
    });

    test('selectRound updates chart only after load for that round', () async {
      final (controller, container) = createController(
        fetchSeasonRacesForTest: (_) async => _threeRaces,
        fetchDriversStandingsForTest: (_, round) async =>
            _standingsDrivers(round: round, points: round == '1' ? '25' : '50'),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
      );

      await controller.loadSeason();
      SeasonRewindState state() => container.read(seasonRewindScreenControllerProvider);
      expect(state().chartRound, '3');
      expect(state().selectedRace?.raceName, 'Australian Grand Prix');

      controller.previewRound(0);
      expect(state().selectedRoundIndex, 0);
      expect(state().selectedRace?.raceName, 'Bahrain Grand Prix');
      expect(state().isChartStale, isTrue);
      expect(state().chartLoading, isFalse);
      expect(state().chartDrivers.first.points, '50');

      await controller.selectRound(0);
      expect(state().chartLoading, isFalse);
      expect(state().isChartStale, isFalse);
      expect(state().chartRound, '1');
      expect(state().selectedRace?.raceName, 'Bahrain Grand Prix');
      expect(state().chartDrivers.first.points, '25');
    });

    test('empty completed races clears standings', () async {
      final (controller, container) = createController(
        fetchSeasonRacesForTest: (_) async => [_race(round: '1', name: 'Future GP', date: '2099-01-01')],
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
      );

      await controller.loadSeason();

      final state = container.read(seasonRewindScreenControllerProvider);
      expect(state.races.value, isEmpty);
      expect(state.hasChartData, isFalse);
      expect(state.chartRound, isNull);
    });

    test('refreshAll reloads season', () async {
      var raceCalls = 0;
      final (controller, container) = createController(
        fetchSeasonRacesForTest: (_) async {
          raceCalls++;
          return _threeRaces;
        },
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
      );

      await controller.refreshAll();

      expect(raceCalls, 1);
      final state = container.read(seasonRewindScreenControllerProvider);
      expect(state.races.isValue, isTrue);
      expect(state.hasChartData, isTrue);
    });

    test('togglePlayback starts and stops', () async {
      final (controller, container) = createController(
        fetchSeasonRacesForTest: (_) async => _threeRaces,
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
        playInterval: const Duration(days: 1),
      );

      await controller.loadSeason();
      expect(container.read(seasonRewindScreenControllerProvider).isPlaying, isFalse);

      controller.togglePlayback();
      expect(container.read(seasonRewindScreenControllerProvider).isPlaying, isTrue);

      controller.togglePlayback();
      expect(container.read(seasonRewindScreenControllerProvider).isPlaying, isFalse);
    });

    test('startPlayback from last round restarts at first', () async {
      final (controller, container) = createController(
        fetchSeasonRacesForTest: (_) async => _threeRaces,
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
        playInterval: const Duration(days: 1),
      );

      await controller.loadSeason();
      expect(container.read(seasonRewindScreenControllerProvider).selectedRoundIndex, 2);

      controller.startPlayback();
      await Future<void>.delayed(Duration.zero);

      final state = container.read(seasonRewindScreenControllerProvider);
      expect(state.selectedRoundIndex, 0);
      expect(state.isPlaying, isTrue);
    });

    test('screenError when races fail', () async {
      final (controller, container) = createController(
        fetchSeasonRacesForTest: (_) async => throw Exception('races down'),
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
      );

      await controller.loadSeason();

      final state = container.read(seasonRewindScreenControllerProvider);
      expect(state.races.isError, isTrue);
      expect(state.screenError, isNotNull);
    });

    test('canPlay is false for a single race', () async {
      final (controller, container) = createController(
        fetchSeasonRacesForTest: (_) async => [_race(round: '1', name: 'Only GP', date: '2024-03-02')],
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
      );

      await controller.loadSeason();

      expect(container.read(seasonRewindScreenControllerProvider).canPlay, isFalse);
    });
  });
}
