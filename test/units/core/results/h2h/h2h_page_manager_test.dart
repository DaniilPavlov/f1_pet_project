import 'package:f1_pet_project/core/results/h2h/managers/h2h_page_manager.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_entity_compare_data.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_mode.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_round_score.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';
import 'package:f1_pet_project/core/results/h2h/providers.dart';
import 'package:f1_pet_project/core/results/h2h/repositories/h2h_repository.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_table_model.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_repositories.dart';

class _FakeH2hRepository extends H2hRepository {
  const _FakeH2hRepository(this.loaded);

  final H2hLoadedCompare loaded;

  @override
  Future<H2hLoadedCompare> compareDrivers({
    required String driverIdA,
    required String driverIdB,
    String? season,
  }) async => loaded;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const stats = H2hStats(races: 10, wins: 3, podiums: 5, poles: 2);
  final timeline = H2hPointsTimeline.fromScores(
    scoresA: const [
      H2hRoundScore(season: '2024', round: '1', raceName: 'Bahrain', points: 25),
      H2hRoundScore(season: '2024', round: '2', raceName: 'Saudi', points: 18),
    ],
    scoresB: const [
      H2hRoundScore(season: '2024', round: '1', raceName: 'Bahrain', points: 18),
      H2hRoundScore(season: '2024', round: '2', raceName: 'Saudi', points: 25),
    ],
  );
  final loaded = H2hLoadedCompare(statsA: stats, statsB: stats, timeline: timeline);

  final driverB = DriverModel(
    driverId: 'charles_leclerc',
    url: 'http://example.com/lec',
    givenName: 'Charles',
    familyName: 'Leclerc',
    dateOfBirth: '1997-10-16',
    nationality: 'Monegasque',
    code: 'LEC',
    permanentNumber: '16',
  );

  const mode = H2hMode.drivers;

  ProviderContainer buildContainer({
    FakeSeasonsRepository? seasonsRepository,
    FakeCurrentStandingsRepository? currentStandings,
    Future<H2hLoadedCompare> Function({required String driverIdA, required String driverIdB, String? season})?
    compareDriversForTest,
    Future<List<DriverModel>> Function()? loadCurrentDriversForTest,
    Future<List<DriverModel>> Function()? loadAllDriversForTest,
    bool useH2hRepository = false,
  }) {
    return ProviderContainer(
      overrides: [
        if (currentStandings != null) currentStandingsRepositoryProvider.overrideWithValue(currentStandings),
        if (useH2hRepository) h2hRepositoryProvider.overrideWithValue(_FakeH2hRepository(loaded)),
        h2hPageManagerProvider(mode).overrideWith((ref) {
          return H2hPageManager(
            holder: ref.watch(h2hPageStateHolderProvider(mode).notifier),
            seasonsRepository: seasonsRepository,
            h2hRepository: useH2hRepository ? ref.watch(h2hRepositoryProvider) : null,
            currentStandingsRepository: currentStandings,
            compareDriversForTest: compareDriversForTest,
            loadCurrentDriversForTest:
                loadCurrentDriversForTest ?? () async => [ControllerFixtures.driver, driverB],
            loadAllDriversForTest: loadAllDriversForTest ?? () async => [ControllerFixtures.driver, driverB],
            analytics: const NoOpAnalyticsGateway(),
          );
        }),
      ],
    );
  }

  group('H2hPageManager', () {
    test('compare loads stats and timeline for both drivers', () async {
      final container = buildContainer(
        compareDriversForTest: ({required driverIdA, required driverIdB, season}) async => loaded,
      );
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode))
        ..setDriverA(ControllerFixtures.driver)
        ..setDriverB(driverB);

      await manager.compare();

      final state = container.read(h2hPageStateHolderProvider(mode));
      expect(state.comparison.isValue, isTrue);
      expect(state.comparison.value?.statsA.wins, 3);
      expect(state.comparison.value?.statsB.wins, 3);
      expect(state.comparison.value?.timeline.points, hasLength(2));
      expect(state.comparison.value?.timeline.points.last.cumulativeA, 43);
    });

    test('compare attaches constructor ids from current standings for chart colors', () async {
      final ferrari = ConstructorModel(
        constructorId: 'ferrari',
        url: 'http://example.com/ferrari',
        name: 'Ferrari',
        nationality: 'Italian',
      );
      final standings = StandingsModel(
        standingsTable: StandingsTableModel(
          standingsLists: [
            StandingsListsModel(
              season: '2026',
              round: '1',
              driverStandings: [
                DriverStandingsModel(
                  position: '1',
                  positionText: '1',
                  points: '10',
                  wins: '0',
                  driver: ControllerFixtures.driver,
                  constructors: [ControllerFixtures.constructor],
                ),
                DriverStandingsModel(
                  position: '2',
                  positionText: '2',
                  points: '8',
                  wins: '0',
                  driver: driverB,
                  constructors: [ferrari],
                ),
              ],
              constructorStandings: null,
            ),
          ],
        ),
      );

      final container = buildContainer(
        currentStandings: FakeCurrentStandingsRepository(drivers: standings),
        useH2hRepository: true,
      );
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode))
        ..setDriverA(ControllerFixtures.driver)
        ..setDriverB(driverB);

      await manager.compare();

      final state = container.read(h2hPageStateHolderProvider(mode));
      expect(state.comparison.value?.constructorIdA, 'red_bull');
      expect(state.comparison.value?.constructorIdB, 'ferrari');
    });

    test('compare leaves constructor ids null when standings miss drivers', () async {
      final emptyStandings = StandingsModel(
        standingsTable: StandingsTableModel(
          standingsLists: [
            StandingsListsModel(season: '2026', round: '1', driverStandings: const [], constructorStandings: null),
          ],
        ),
      );

      final container = buildContainer(
        currentStandings: FakeCurrentStandingsRepository(drivers: emptyStandings),
        useH2hRepository: true,
      );
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode))
        ..setDriverA(ControllerFixtures.driver)
        ..setDriverB(driverB);

      await manager.compare();

      final state = container.read(h2hPageStateHolderProvider(mode));
      expect(state.comparison.value?.constructorIdA, isNull);
      expect(state.comparison.value?.constructorIdB, isNull);
    });

    test('refreshComparison retries after clear (forTest path)', () async {
      var calls = 0;
      final container = buildContainer(
        compareDriversForTest: ({required driverIdA, required driverIdB, season}) async {
          calls++;
          if (calls <= 1) {
            throw ResponseParseException('fail');
          }
          return loaded;
        },
      );
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode))
        ..setDriverA(ControllerFixtures.driver)
        ..setDriverB(driverB);

      await manager.compare();
      expect(container.read(h2hPageStateHolderProvider(mode)).comparison.isError, isTrue);

      await manager.refreshComparison();
      expect(container.read(h2hPageStateHolderProvider(mode)).comparison.isValue, isTrue);
    });

    test('canCompare requires distinct drivers', () {
      final container = buildContainer(
        compareDriversForTest: ({required driverIdA, required driverIdB, season}) async => loaded,
      );
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode))..setDriverA(ControllerFixtures.driver);

      expect(manager.canCompare, isFalse);

      manager.setDriverB(ControllerFixtures.driver);
      expect(manager.canCompare, isFalse);

      manager.setDriverB(driverB);
      expect(manager.canCompare, isTrue);
      expect(container.read(h2hPageStateHolderProvider(mode)).driverA, isNotNull);
    });

    test('season scope blocks compare until season is known', () async {
      final container = buildContainer(
        seasonsRepository: FakeSeasonsRepository(years: ['2024']),
        compareDriversForTest: ({required driverIdA, required driverIdB, season}) async => loaded,
      );
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode))
        ..setDriverA(ControllerFixtures.driver)
        ..setDriverB(driverB)
        ..setScopeMode(1);

      expect(manager.canCompare, isFalse);

      await manager.bootstrap();
      expect(manager.canCompare, isTrue);
      expect(manager.selectedSeason, '2024');
    });

    test('loadDriversForPicker respects currentEntitiesOnly', () async {
      final current = [ControllerFixtures.driver];
      final all = [ControllerFixtures.driver, driverB];
      final container = buildContainer(
        loadCurrentDriversForTest: () async => current,
        loadAllDriversForTest: () async => all,
        compareDriversForTest: ({required driverIdA, required driverIdB, season}) async => loaded,
      );
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode));

      expect(await manager.loadDriversForPicker(), current);

      manager.setCurrentEntitiesOnly(false);
      expect(await manager.loadDriversForPicker(), all);
      expect(container.read(h2hPageStateHolderProvider(mode)).driverA, isNull);
      expect(container.read(h2hPageStateHolderProvider(mode)).driverB, isNull);
    });

    test('filters reset comparison and year picker mode', () async {
      final container = buildContainer(
        compareDriversForTest: ({required driverIdA, required driverIdB, season}) async => loaded,
      );
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode))
        ..setDriverA(ControllerFixtures.driver)
        ..setDriverB(driverB);

      await manager.compare();
      expect(container.read(h2hPageStateHolderProvider(mode)).comparison.isValue, isTrue);

      manager.setScopeMode(1);
      expect(container.read(h2hPageStateHolderProvider(mode)).comparison.value, isNull);
      expect(container.read(h2hPageStateHolderProvider(mode)).showYearPicker, isFalse);

      manager.setUseCurrentSeason(false);
      expect(container.read(h2hPageStateHolderProvider(mode)).showYearPicker, isTrue);

      manager.yearController.text = '2024';
      manager.onSeasonChanged();
      expect(container.read(h2hPageStateHolderProvider(mode)).seasonSelected, isTrue);
      expect(manager.selectedSeason, '2024');

      manager
        ..setScopeMode(1) // no-op
        ..setUseCurrentSeason(false); // no-op
    });

    test('bootstrap loads latest season years', () async {
      final container = buildContainer(
        seasonsRepository: FakeSeasonsRepository(years: ['2025', '2024']),
        compareDriversForTest: ({required driverIdA, required driverIdB, season}) async => loaded,
      );
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode));

      await manager.bootstrap();

      expect(container.read(h2hPageStateHolderProvider(mode)).latestSeason, '2025');
      expect(manager.yearController.text, '2025');
      expect(container.read(h2hPageStateHolderProvider(mode)).seasonSelected, isTrue);
    });

    test('bootstrap ignores seasons repository failures', () async {
      final container = buildContainer(
        seasonsRepository: FakeSeasonsRepository(throwOnLoad: true),
        compareDriversForTest: ({required driverIdA, required driverIdB, season}) async => loaded,
      );
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode));

      await manager.bootstrap();

      expect(container.read(h2hPageStateHolderProvider(mode)).latestSeason, isEmpty);
    });

    test('compare no-ops when canCompare is false', () async {
      var calls = 0;
      final container = buildContainer(
        compareDriversForTest: ({required driverIdA, required driverIdB, season}) async {
          calls++;
          return loaded;
        },
      );
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode))..setDriverA(ControllerFixtures.driver);

      await manager.compare();
      expect(calls, 0);
    });

    test('screenError exposes compare failure', () async {
      final container = buildContainer(
        compareDriversForTest: ({required driverIdA, required driverIdB, season}) async {
          throw ResponseParseException('boom');
        },
      );
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode))
        ..setDriverA(ControllerFixtures.driver)
        ..setDriverB(driverB);

      await manager.compare();
      expect(container.read(h2hPageStateHolderProvider(mode)).screenError, isNotNull);
    });
  });
}
