import 'package:f1_pet_project/core/results/season_rewind/managers/season_rewind_page_manager.dart';
import 'package:f1_pet_project/core/results/season_rewind/providers.dart';
import 'package:f1_pet_project/core/results/season_rewind/state/state_models/season_rewind_page_view_model.dart';
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

  ProviderContainer buildContainer({
    FakeSeasonsRepository? seasonsRepository,
    Future<List<RacesModel>> Function(String year)? fetchSeasonRacesForTest,
    Future<StandingsModel> Function(String year, String round)? fetchDriversStandingsForTest,
    Future<StandingsModel> Function(String year, String round)? fetchConstructorsStandingsForTest,
    Duration playInterval = const Duration(milliseconds: 1500),
  }) {
    final container = ProviderContainer(
      overrides: [
        seasonRewindPageManagerProvider.overrideWith((ref) {
          final manager = SeasonRewindPageManager(
            holder: ref.watch(seasonRewindPageStateHolderProvider.notifier),
            seasonsRepository: seasonsRepository,
            fetchSeasonRacesForTest: fetchSeasonRacesForTest,
            fetchDriversStandingsForTest: fetchDriversStandingsForTest,
            fetchConstructorsStandingsForTest: fetchConstructorsStandingsForTest,
            playInterval: playInterval,
          );
          ref.onDispose(manager.dispose);
          return manager;
        }),
      ],
    )..listen(seasonRewindPageStateHolderProvider, (_, _) {})
      ..listen(seasonRewindPageManagerProvider, (_, _) {});
    return container;
  }

  group('SeasonRewindPageManager', () {
    test('completedRacesAsOf drops future rounds', () {
      final races = [
        _race(round: '1', name: 'A', date: '2024-03-01'),
        _race(round: '2', name: 'B', date: '2024-03-15'),
        _race(round: '3', name: 'C', date: '2099-12-01'),
      ];

      final completed = SeasonRewindPageManager.completedRacesAsOf(races, DateTime.utc(2024, 3, 15));

      expect(completed.map((r) => r.round), ['1', '2']);
    });

    test('bootstrap sets year, races and standings', () async {
      final container = buildContainer(
        seasonsRepository: FakeSeasonsRepository(years: ['2024', '2023']),
        fetchSeasonRacesForTest: (_) async => _threeRaces,
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
      );
      addTearDown(container.dispose);

      final manager = container.read(seasonRewindPageManagerProvider);
      await manager.bootstrap();

      expect(manager.yearController.text, '2024');
      final state = container.read(seasonRewindPageStateHolderProvider);
      expect(state.races.value?.length, 3);
      expect(state.selectedRoundIndex, 2);
      expect(state.selectedRace?.raceName, 'Australian Grand Prix');
      expect(state.chartRound, '3');
      expect(state.hasChartData, isTrue);
    });

    test('selectRound updates chart only after load for that round', () async {
      final container = buildContainer(
        fetchSeasonRacesForTest: (_) async => _threeRaces,
        fetchDriversStandingsForTest: (_, round) async =>
            _standingsDrivers(round: round, points: round == '1' ? '25' : '50'),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
      );
      addTearDown(container.dispose);

      final manager = container.read(seasonRewindPageManagerProvider);
      await manager.loadSeason();
      SeasonRewindPageViewModel state() => container.read(seasonRewindPageStateHolderProvider);
      expect(state().chartRound, '3');
      expect(state().selectedRace?.raceName, 'Australian Grand Prix');

      manager.previewRound(0);
      expect(state().selectedRoundIndex, 0);
      expect(state().selectedRace?.raceName, 'Bahrain Grand Prix');
      expect(state().isChartStale, isTrue);
      expect(state().chartLoading, isFalse);
      expect(state().chartDrivers.first.points, '50');

      await manager.selectRound(0);
      expect(state().chartLoading, isFalse);
      expect(state().isChartStale, isFalse);
      expect(state().chartRound, '1');
      expect(state().selectedRace?.raceName, 'Bahrain Grand Prix');
      expect(state().chartDrivers.first.points, '25');
    });

    test('empty completed races clears standings', () async {
      final container = buildContainer(
        fetchSeasonRacesForTest: (_) async => [_race(round: '1', name: 'Future GP', date: '2099-01-01')],
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
      );
      addTearDown(container.dispose);

      await container.read(seasonRewindPageManagerProvider).loadSeason();

      final state = container.read(seasonRewindPageStateHolderProvider);
      expect(state.races.value, isEmpty);
      expect(state.hasChartData, isFalse);
      expect(state.chartRound, isNull);
    });

    test('refreshAll reloads season', () async {
      var raceCalls = 0;
      final container = buildContainer(
        fetchSeasonRacesForTest: (_) async {
          raceCalls++;
          return _threeRaces;
        },
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
      );
      addTearDown(container.dispose);

      await container.read(seasonRewindPageManagerProvider).refreshAll();

      expect(raceCalls, 1);
      final state = container.read(seasonRewindPageStateHolderProvider);
      expect(state.races.isValue, isTrue);
      expect(state.hasChartData, isTrue);
    });

    test('togglePlayback starts and stops', () async {
      final container = buildContainer(
        fetchSeasonRacesForTest: (_) async => _threeRaces,
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
        playInterval: const Duration(days: 1),
      );
      addTearDown(container.dispose);

      final manager = container.read(seasonRewindPageManagerProvider);
      await manager.loadSeason();
      expect(container.read(seasonRewindPageStateHolderProvider).isPlaying, isFalse);

      manager.togglePlayback();
      expect(container.read(seasonRewindPageStateHolderProvider).isPlaying, isTrue);

      manager.togglePlayback();
      expect(container.read(seasonRewindPageStateHolderProvider).isPlaying, isFalse);
    });

    test('startPlayback from last round restarts at first', () async {
      final container = buildContainer(
        fetchSeasonRacesForTest: (_) async => _threeRaces,
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
        playInterval: const Duration(days: 1),
      );
      addTearDown(container.dispose);

      final manager = container.read(seasonRewindPageManagerProvider);
      await manager.loadSeason();
      expect(container.read(seasonRewindPageStateHolderProvider).selectedRoundIndex, 2);

      manager.startPlayback();
      await Future<void>.delayed(Duration.zero);

      final state = container.read(seasonRewindPageStateHolderProvider);
      expect(state.selectedRoundIndex, 0);
      expect(state.isPlaying, isTrue);
    });

    test('screenError when races fail', () async {
      final container = buildContainer(
        fetchSeasonRacesForTest: (_) async => throw Exception('races down'),
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
      );
      addTearDown(container.dispose);

      await container.read(seasonRewindPageManagerProvider).loadSeason();

      final state = container.read(seasonRewindPageStateHolderProvider);
      expect(state.races.isError, isTrue);
      expect(state.screenError, isNotNull);
    });

    test('canPlay is false for a single race', () async {
      final container = buildContainer(
        fetchSeasonRacesForTest: (_) async => [_race(round: '1', name: 'Only GP', date: '2024-03-02')],
        fetchDriversStandingsForTest: (_, round) async => _standingsDrivers(round: round),
        fetchConstructorsStandingsForTest: (_, round) async => _standingsConstructors(round: round),
      );
      addTearDown(container.dispose);

      await container.read(seasonRewindPageManagerProvider).loadSeason();

      expect(container.read(seasonRewindPageStateHolderProvider).canPlay, isFalse);
    });
  });
}
