import 'package:f1_pet_project/core/results/h2h/controllers/h2h_screen_controller/h2h_screen_controller.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const stats = H2hStats(races: 10, wins: 3, podiums: 5, poles: 2);

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
    test('compare loads stats for both drivers', () async {
      final controller = H2hScreenController(
        loadCurrentDriversForTest: () async => [ControllerFixtures.driver, driverB],
        loadAllDriversForTest: () async => [ControllerFixtures.driver, driverB],
        fetchStatsForTest: ({required driverId, season}) async => stats,
      )
        ..setDriverA(ControllerFixtures.driver)
        ..setDriverB(driverB);

      await controller.compare();

      expect(controller.comparison.isValue, isTrue);
      expect(controller.comparison.value?.statsA.wins, 3);
      expect(controller.comparison.value?.statsB.wins, 3);
      controller.dispose();
    });

    test('refreshComparison retries after clear (forTest path)', () async {
      var calls = 0;
      final controller = H2hScreenController(
        loadCurrentDriversForTest: () async => [ControllerFixtures.driver, driverB],
        loadAllDriversForTest: () async => [ControllerFixtures.driver, driverB],
        fetchStatsForTest: ({required driverId, season}) async {
          calls++;
          if (calls <= 2) {
            throw ResponseParseException('fail');
          }
          return stats;
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
