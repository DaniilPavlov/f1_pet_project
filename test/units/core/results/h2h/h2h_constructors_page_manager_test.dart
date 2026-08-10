import 'package:f1_pet_project/core/results/h2h/managers/h2h_page_manager.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_entity_compare_data.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_mode.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_round_score.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';
import 'package:f1_pet_project/core/results/h2h/providers.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_repositories.dart';

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

  final constructorB = ConstructorModel(
    constructorId: 'ferrari',
    url: 'http://example.com/ferrari',
    name: 'Ferrari',
    nationality: 'Italian',
  );

  const mode = H2hMode.constructors;

  ProviderContainer buildContainer({
    Future<H2hLoadedCompare> Function({required String constructorIdA, required String constructorIdB, String? season})?
    compare,
    Future<List<ConstructorModel>> Function()? loadCurrent,
    Future<List<ConstructorModel>> Function()? loadAll,
    FakeSeasonsRepository? seasons,
  }) {
    return ProviderContainer(
      overrides: [
        h2hPageManagerProvider(mode).overrideWith((ref) {
          return H2hPageManager(
            holder: ref.watch(h2hPageStateHolderProvider(mode).notifier),
            seasonsRepository: seasons,
            loadCurrentConstructorsForTest:
                loadCurrent ?? () async => [ControllerFixtures.constructor, constructorB],
            loadAllConstructorsForTest: loadAll ?? () async => [ControllerFixtures.constructor, constructorB],
            compareConstructorsForTest:
                compare ?? ({required constructorIdA, required constructorIdB, season}) async => loaded,
            analytics: const NoOpAnalyticsGateway(),
          );
        }),
      ],
    );
  }

  group('H2hPageManager constructors mode', () {
    test('compare loads stats and timeline for both constructors', () async {
      final container = buildContainer();
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode))
        ..setConstructorA(ControllerFixtures.constructor)
        ..setConstructorB(constructorB);

      await manager.compare();

      final state = container.read(h2hPageStateHolderProvider(mode));
      expect(state.comparison.isValue, isTrue);
      expect(state.comparison.value?.statsA.wins, 3);
      expect(state.comparison.value?.nameA, 'Red Bull');
      expect(state.comparison.value?.timeline.points.last.cumulativeA, 43);
    });

    test('canCompare requires distinct constructors', () {
      final container = buildContainer();
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode))
        ..setConstructorA(ControllerFixtures.constructor);

      expect(manager.canCompare, isFalse);

      manager.setConstructorB(ControllerFixtures.constructor);
      expect(manager.canCompare, isFalse);

      manager.setConstructorB(constructorB);
      expect(manager.canCompare, isTrue);
    });

    test('setMode switches and clears selections', () {
      final container = buildContainer();
      addTearDown(container.dispose);
      container.read(h2hPageManagerProvider(mode))
        ..setConstructorA(ControllerFixtures.constructor)
        ..setConstructorB(constructorB)
        ..setMode(H2hMode.drivers);

      final state = container.read(h2hPageStateHolderProvider(mode));
      expect(state.isDriversMode, isTrue);
      expect(state.constructorA, isNull);
      expect(state.constructorB, isNull);
    });

    test('loadConstructorsForPicker respects currentEntitiesOnly', () async {
      final current = [ControllerFixtures.constructor];
      final all = [ControllerFixtures.constructor, constructorB];
      final container = buildContainer(loadCurrent: () async => current, loadAll: () async => all);
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode));

      expect(await manager.loadConstructorsForPicker(), current);

      manager.setCurrentEntitiesOnly(false);
      expect(await manager.loadConstructorsForPicker(), all);
      expect(container.read(h2hPageStateHolderProvider(mode)).constructorA, isNull);
    });

    test('refreshComparison retries after clear', () async {
      var calls = 0;
      final container = buildContainer(
        compare: ({required constructorIdA, required constructorIdB, season}) async {
          calls++;
          if (calls <= 1) {
            throw ResponseParseException('fail');
          }
          return loaded;
        },
      );
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode))
        ..setConstructorA(ControllerFixtures.constructor)
        ..setConstructorB(constructorB);

      await manager.compare();
      expect(container.read(h2hPageStateHolderProvider(mode)).comparison.isError, isTrue);

      await manager.refreshComparison();
      expect(container.read(h2hPageStateHolderProvider(mode)).comparison.isValue, isTrue);
    });

    test('bootstrap loads latest season years', () async {
      final container = buildContainer(seasons: FakeSeasonsRepository(years: ['2025', '2024']));
      addTearDown(container.dispose);
      final manager = container.read(h2hPageManagerProvider(mode));

      await manager.bootstrap();

      expect(container.read(h2hPageStateHolderProvider(mode)).latestSeason, '2025');
      expect(manager.yearController.text, '2025');
      expect(container.read(h2hPageStateHolderProvider(mode)).seasonSelected, isTrue);
    });
  });
}
