import 'package:f1_pet_project/core/results/h2h/controllers/h2h_screen_controller/h2h_screen_controller.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_entity_compare_data.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_mode.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_round_score.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/riverpod_container.dart';

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

  (H2hScreenController, ProviderContainer) createController({
    Future<H2hLoadedCompare> Function({required String constructorIdA, required String constructorIdB, String? season})?
    compare,
    Future<List<ConstructorModel>> Function()? loadCurrent,
    Future<List<ConstructorModel>> Function()? loadAll,
    FakeSeasonsRepository? seasons,
  }) {
    late H2hScreenController controller;
    final container = createNotifierContainer(
      overrides: [
        h2hScreenControllerProvider(mode).overrideWith(
          () => controller = H2hScreenController(
            mode,
            seasonsRepositoryForTest: seasons,
            loadCurrentConstructorsForTest: loadCurrent ?? () async => [ControllerFixtures.constructor, constructorB],
            loadAllConstructorsForTest: loadAll ?? () async => [ControllerFixtures.constructor, constructorB],
            compareConstructorsForTest:
                compare ?? ({required constructorIdA, required constructorIdB, season}) async => loaded,
            analyticsForTest: const NoOpAnalyticsGateway(),
          ),
        ),
      ],
    )..listen(h2hScreenControllerProvider(mode), (_, _) {});
    controller = container.read(h2hScreenControllerProvider(mode).notifier);
    return (controller, container);
  }

  H2hState stateOf(ProviderContainer container) => container.read(h2hScreenControllerProvider(mode));

  group('H2hScreenController constructors mode', () {
    test('compare loads stats and timeline for both constructors', () async {
      final (controller, container) = createController();
      controller
        ..setConstructorA(ControllerFixtures.constructor)
        ..setConstructorB(constructorB);

      await controller.compare();

      final state = stateOf(container);
      expect(state.comparison.isValue, isTrue);
      expect(state.comparison.value?.statsA.wins, 3);
      expect(state.comparison.value?.nameA, 'Red Bull');
      expect(state.comparison.value?.timeline.points.last.cumulativeA, 43);
    });

    test('canCompare requires distinct constructors', () {
      final (controller, _) = createController();
      controller.setConstructorA(ControllerFixtures.constructor);

      expect(controller.canCompare, isFalse);

      controller.setConstructorB(ControllerFixtures.constructor);
      expect(controller.canCompare, isFalse);

      controller.setConstructorB(constructorB);
      expect(controller.canCompare, isTrue);
    });

    test('setMode switches and clears selections', () {
      final (controller, container) = createController();
      controller
        ..setConstructorA(ControllerFixtures.constructor)
        ..setConstructorB(constructorB)
        ..setMode(H2hMode.drivers);

      final state = stateOf(container);
      expect(state.isDriversMode, isTrue);
      expect(state.constructorA, isNull);
      expect(state.constructorB, isNull);
    });

    test('loadConstructorsForPicker respects currentEntitiesOnly', () async {
      final current = [ControllerFixtures.constructor];
      final all = [ControllerFixtures.constructor, constructorB];
      final (controller, container) = createController(loadCurrent: () async => current, loadAll: () async => all);

      expect(await controller.loadConstructorsForPicker(), current);

      controller.setCurrentEntitiesOnly(false);
      expect(await controller.loadConstructorsForPicker(), all);
      expect(stateOf(container).constructorA, isNull);
    });

    test('refreshComparison retries after clear', () async {
      var calls = 0;
      final (controller, container) = createController(
        compare: ({required constructorIdA, required constructorIdB, season}) async {
          calls++;
          if (calls <= 1) {
            throw ResponseParseException('fail');
          }
          return loaded;
        },
      );
      controller
        ..setConstructorA(ControllerFixtures.constructor)
        ..setConstructorB(constructorB);

      await controller.compare();
      expect(stateOf(container).comparison.isError, isTrue);

      await controller.refreshComparison();
      expect(stateOf(container).comparison.isValue, isTrue);
    });

    test('bootstrap loads latest season years', () async {
      final (controller, container) = createController(seasons: FakeSeasonsRepository(years: ['2025', '2024']));

      await controller.bootstrap();

      expect(stateOf(container).latestSeason, '2025');
      expect(controller.yearController.text, '2025');
      expect(stateOf(container).seasonSelected, isTrue);
    });
  });
}
