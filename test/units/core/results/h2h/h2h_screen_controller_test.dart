import 'package:f1_pet_project/core/results/h2h/controllers/h2h_screen_controller/h2h_screen_controller.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_entity_compare_data.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_round_score.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';

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

  group('H2hScreenController', () {
    test('compare loads stats and timeline for both drivers', () async {
      final controller = H2hScreenController(
        loadCurrentDriversForTest: () async => [ControllerFixtures.driver, driverB],
        loadAllDriversForTest: () async => [ControllerFixtures.driver, driverB],
        compareForTest: ({required driverIdA, required driverIdB, season}) async => loaded,
      )
        ..setDriverA(ControllerFixtures.driver)
        ..setDriverB(driverB);

      await controller.compare();

      expect(controller.comparison.isValue, isTrue);
      expect(controller.comparison.value?.statsA.wins, 3);
      expect(controller.comparison.value?.statsB.wins, 3);
      expect(controller.comparison.value?.timeline.points, hasLength(2));
      expect(controller.comparison.value?.timeline.points.last.cumulativeA, 43);
      controller.dispose();
    });

    test('refreshComparison retries after clear (forTest path)', () async {
      var calls = 0;
      final controller = H2hScreenController(
        loadCurrentDriversForTest: () async => [ControllerFixtures.driver, driverB],
        loadAllDriversForTest: () async => [ControllerFixtures.driver, driverB],
        compareForTest: ({required driverIdA, required driverIdB, season}) async {
          calls++;
          if (calls <= 1) {
            throw ResponseParseException('fail');
          }
          return loaded;
        },
      )
        ..setDriverA(ControllerFixtures.driver)
        ..setDriverB(driverB);

      await controller.compare();
      expect(controller.comparison.isError, isTrue);

      await controller.refreshComparison();
      expect(controller.comparison.isValue, isTrue);
      controller.dispose();
    });
  });
}
