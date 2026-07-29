import 'package:f1_pet_project/core/results/hall_of_fame/repositories/season_standings_repository.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_request_handler.dart';
import '../../../../helpers/jolpica_fixtures.dart';

void main() {
  group('SeasonStandingsRepository', () {
    test('loads drivers and constructors standings', () async {
      final handler = FakeRequestHandler(
        responses: {
          '2024/driverStandings': {'MRData': JolpicaFixtures.driversStandingsMrData()},
          '2024/constructorStandings': {'MRData': JolpicaFixtures.constructorsStandingsMrData()},
        },
      );
      ApiLoader.configure(handler);
      const repo = SeasonStandingsRepository();

      final drivers = await repo.drivers(year: '2024');
      final constructors = await repo.constructors(year: '2024');

      expect(drivers.standingsTable.standingsLists, isNotEmpty);
      expect(constructors.standingsTable.standingsLists, isNotEmpty);
      expect(
        handler.calls.map((c) => c.path),
        ['2024/driverStandings', '2024/constructorStandings'],
      );
    });
  });
}
