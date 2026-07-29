import 'package:f1_pet_project/core/results/h2h/controllers/h2h_constructors_screen_controller/h2h_constructors_screen_controller.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_entity_compare_data.dart';
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

  group('H2hConstructorsScreenController', () {
    test('compare loads stats and timeline for both constructors', () async {
      final controller = H2hConstructorsScreenController(
        loadCurrentConstructorsForTest: () async => [ControllerFixtures.constructor, constructorB],
        loadAllConstructorsForTest: () async => [ControllerFixtures.constructor, constructorB],
        compareForTest: ({required constructorIdA, required constructorIdB, season}) async => loaded,
      )
        ..setConstructorA(ControllerFixtures.constructor)
        ..setConstructorB(constructorB);

      await controller.compare();

      expect(controller.comparison.isValue, isTrue);
      expect(controller.comparison.value?.statsA.wins, 3);
      expect(controller.comparison.value?.statsB.wins, 3);
      expect(controller.comparison.value?.timeline.points, hasLength(2));
      expect(controller.comparison.value?.timeline.points.last.cumulativeA, 43);
      controller.dispose();
    });

    test('canCompare requires distinct constructors', () {
      final controller = H2hConstructorsScreenController(
        loadCurrentConstructorsForTest: () async => [ControllerFixtures.constructor],
        loadAllConstructorsForTest: () async => [ControllerFixtures.constructor],
        compareForTest: ({required constructorIdA, required constructorIdB, season}) async => loaded,
      )..setConstructorA(ControllerFixtures.constructor);

      expect(controller.canCompare, isFalse);

      controller.setConstructorB(ControllerFixtures.constructor);
      expect(controller.canCompare, isFalse);

      controller.setConstructorB(constructorB);
      expect(controller.canCompare, isTrue);
      controller.dispose();
    });

    test('season scope blocks compare until season is known', () {
      final controller = H2hConstructorsScreenController(
        loadCurrentConstructorsForTest: () async => [ControllerFixtures.constructor, constructorB],
        loadAllConstructorsForTest: () async => [ControllerFixtures.constructor, constructorB],
        compareForTest: ({required constructorIdA, required constructorIdB, season}) async => loaded,
      )
        ..setConstructorA(ControllerFixtures.constructor)
        ..setConstructorB(constructorB)
        ..setScopeMode(1);

      expect(controller.isSeasonScope, isTrue);
      expect(controller.canCompare, isFalse);

      controller.latestSeason = '2024';
      expect(controller.canCompare, isTrue);
      expect(controller.selectedSeason, '2024');
      controller.dispose();
    });

    test('loadConstructorsForPicker respects currentConstructorsOnly', () async {
      final current = [ControllerFixtures.constructor];
      final all = [ControllerFixtures.constructor, constructorB];
      final controller = H2hConstructorsScreenController(
        loadCurrentConstructorsForTest: () async => current,
        loadAllConstructorsForTest: () async => all,
        compareForTest: ({required constructorIdA, required constructorIdB, season}) async => loaded,
      );

      expect(await controller.loadConstructorsForPicker(), current);

      controller.setCurrentConstructorsOnly(false);
      expect(await controller.loadConstructorsForPicker(), all);
      expect(controller.constructorA, isNull);
      expect(controller.constructorB, isNull);
      controller.dispose();
    });

    test('refreshComparison retries after clear (forTest path)', () async {
      var calls = 0;
      final controller = H2hConstructorsScreenController(
        loadCurrentConstructorsForTest: () async => [ControllerFixtures.constructor, constructorB],
        loadAllConstructorsForTest: () async => [ControllerFixtures.constructor, constructorB],
        compareForTest: ({required constructorIdA, required constructorIdB, season}) async {
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

    test('filters reset comparison and year picker mode', () async {
      final controller = H2hConstructorsScreenController(
        loadCurrentConstructorsForTest: () async => [ControllerFixtures.constructor, constructorB],
        loadAllConstructorsForTest: () async => [ControllerFixtures.constructor, constructorB],
        compareForTest: ({required constructorIdA, required constructorIdB, season}) async => loaded,
      )
        ..setConstructorA(ControllerFixtures.constructor)
        ..setConstructorB(constructorB);

      await controller.compare();
      expect(controller.comparison.isValue, isTrue);

      controller
        ..setScopeMode(1)
        ..setUseCurrentSeason(false);
      expect(controller.comparison.value, isNull);
      expect(controller.showYearPicker, isTrue);

      controller.yearController.text = '2024';
      controller.onSeasonChanged();
      expect(controller.seasonSelected, isTrue);
      controller.dispose();
    });

    test('year picker selectedSeason and screenError', () async {
      final controller = H2hConstructorsScreenController(
        loadCurrentConstructorsForTest: () async => [ControllerFixtures.constructor, constructorB],
        loadAllConstructorsForTest: () async => [ControllerFixtures.constructor, constructorB],
        compareForTest: ({required constructorIdA, required constructorIdB, season}) async {
          throw ResponseParseException('compare fail');
        },
      )
        ..setConstructorA(ControllerFixtures.constructor)
        ..setConstructorB(constructorB)
        ..setScopeMode(1)
        ..setUseCurrentSeason(false);

      expect(controller.selectedSeason, isNull);
      expect(controller.canCompare, isFalse);

      controller.yearController.text = '2024';
      controller.onSeasonChanged();
      expect(controller.selectedSeason, '2024');
      expect(controller.canCompare, isTrue);

      await controller.compare();
      expect(controller.comparison.isError, isTrue);
      expect(controller.screenError, isNotNull);
      controller.dispose();
    });

    test('bootstrap loads latest season years', () async {
      final controller = H2hConstructorsScreenController(
        seasonsRepository: FakeSeasonsRepository(years: ['2025', '2024']),
        loadCurrentConstructorsForTest: () async => [ControllerFixtures.constructor],
        loadAllConstructorsForTest: () async => [ControllerFixtures.constructor],
        compareForTest: ({required constructorIdA, required constructorIdB, season}) async => loaded,
      );

      await controller.bootstrap();

      expect(controller.latestSeason, '2025');
      expect(controller.yearController.text, '2025');
      expect(controller.seasonSelected, isTrue);
      controller.dispose();
    });
  });
}
