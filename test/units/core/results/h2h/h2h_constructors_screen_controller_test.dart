import 'package:f1_pet_project/core/results/h2h/controllers/h2h_screen_controller/h2h_screen_controller.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_entity_compare_data.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_mode.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_round_score.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
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

  H2hScreenController constructorsController({
    Future<H2hLoadedCompare> Function({required String constructorIdA, required String constructorIdB, String? season})?
    compare,
    Future<List<ConstructorModel>> Function()? loadCurrent,
    Future<List<ConstructorModel>> Function()? loadAll,
    FakeSeasonsRepository? seasons,
  }) {
    return H2hScreenController(
      initialMode: H2hMode.constructors,
      seasonsRepository: seasons,
      loadCurrentConstructorsForTest: loadCurrent ?? () async => [ControllerFixtures.constructor, constructorB],
      loadAllConstructorsForTest: loadAll ?? () async => [ControllerFixtures.constructor, constructorB],
      compareConstructorsForTest:
          compare ?? ({required constructorIdA, required constructorIdB, season}) async => loaded,
    );
  }

  group('H2hScreenController constructors mode', () {
    test('compare loads stats and timeline for both constructors', () async {
      final controller = constructorsController()
        ..setConstructorA(ControllerFixtures.constructor)
        ..setConstructorB(constructorB);

      await controller.compare();

      expect(controller.comparison.isValue, isTrue);
      expect(controller.comparison.value?.statsA.wins, 3);
      expect(controller.comparison.value?.nameA, 'Red Bull');
      expect(controller.comparison.value?.timeline.points.last.cumulativeA, 43);
      controller.dispose();
    });

    test('canCompare requires distinct constructors', () {
      final controller = constructorsController()..setConstructorA(ControllerFixtures.constructor);

      expect(controller.canCompare, isFalse);

      controller.setConstructorB(ControllerFixtures.constructor);
      expect(controller.canCompare, isFalse);

      controller.setConstructorB(constructorB);
      expect(controller.canCompare, isTrue);
      controller.dispose();
    });

    test('setMode switches and clears selections', () {
      final controller = constructorsController()
        ..setConstructorA(ControllerFixtures.constructor)
        ..setConstructorB(constructorB)
        ..setMode(H2hMode.drivers);
      expect(controller.isDriversMode, isTrue);
      expect(controller.constructorA, isNull);
      expect(controller.constructorB, isNull);
      controller.dispose();
    });

    test('loadConstructorsForPicker respects currentEntitiesOnly', () async {
      final current = [ControllerFixtures.constructor];
      final all = [ControllerFixtures.constructor, constructorB];
      final controller = constructorsController(loadCurrent: () async => current, loadAll: () async => all);

      expect(await controller.loadConstructorsForPicker(), current);

      controller.setCurrentEntitiesOnly(false);
      expect(await controller.loadConstructorsForPicker(), all);
      expect(controller.constructorA, isNull);
      controller.dispose();
    });

    test('refreshComparison retries after clear', () async {
      var calls = 0;
      final controller =
          constructorsController(
              compare: ({required constructorIdA, required constructorIdB, season}) async {
                calls++;
                if (calls <= 1) {
                  throw ResponseParseException('fail');
                }
                return loaded;
              },
            )
            ..setConstructorA(ControllerFixtures.constructor)
            ..setConstructorB(constructorB);

      await controller.compare();
      expect(controller.comparison.isError, isTrue);

      await controller.refreshComparison();
      expect(controller.comparison.isValue, isTrue);
      controller.dispose();
    });

    test('bootstrap loads latest season years', () async {
      final controller = constructorsController(seasons: FakeSeasonsRepository(years: ['2025', '2024']));

      await controller.bootstrap();

      expect(controller.latestSeason, '2025');
      expect(controller.yearController.text, '2025');
      expect(controller.seasonSelected, isTrue);
      controller.dispose();
    });
  });
}
