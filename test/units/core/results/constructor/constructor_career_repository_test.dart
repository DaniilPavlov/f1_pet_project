import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_career_repository.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_request_handler.dart';
import '../../../../helpers/jolpica_fixtures.dart';

void main() {
  setUp(CareerApiHelper.resetThrottleForTest);

  group('ConstructorCareerRepository', () {
    test('load aggregates races, podiums and related drivers', () async {
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          if (path == 'constructors/red_bull/results') {
            return JolpicaFixtures.mrDataRaceTable(
              races: [
                JolpicaFixtures.race(
                  season: '2024',
                  round: '1',
                  results: [
                    JolpicaFixtures.resultEntry(position: '1', points: '25'),
                    JolpicaFixtures.resultEntry(position: '2', points: '18'),
                  ],
                ),
                JolpicaFixtures.race(
                  season: '2023',
                  round: '5',
                  raceName: 'Monaco',
                  results: [JolpicaFixtures.resultEntry(position: '1')],
                ),
              ],
              total: 2,
            );
          }
          if (path == 'constructors/red_bull/results/1') {
            return JolpicaFixtures.mrDataRaceTable(
              races: [
                JolpicaFixtures.race(
                  season: '2024',
                  round: '1',
                  results: [JolpicaFixtures.resultEntry(position: '1')],
                ),
              ],
              total: 12,
            );
          }
          if (path == 'constructors/red_bull/results/2') {
            return JolpicaFixtures.mrDataRaceTable(
              races: [
                JolpicaFixtures.race(
                  season: '2024',
                  round: '1',
                  results: [JolpicaFixtures.resultEntry(position: '2')],
                ),
              ],
              total: 1,
            );
          }
          if (path == 'constructors/red_bull/results/3') {
            return JolpicaFixtures.emptyRaceTable();
          }
          if (path == 'constructors/red_bull/qualifying/1') {
            return JolpicaFixtures.mrDataRaceTable(
              races: [
                JolpicaFixtures.race(qualifyingResults: [JolpicaFixtures.qualifyingEntry()]),
              ],
              total: 8,
            );
          }
          if (path == 'constructors/red_bull/drivers') {
            return JolpicaFixtures.mrDataDriverTable(drivers: [JolpicaFixtures.driverJson]);
          }
          throw StateError('unexpected $path');
        },
      );
      ApiLoader.configure(handler);

      final stats = await const ConstructorCareerRepository().load(
        constructorId: 'red_bull',
        current: [ControllerFixtures.driver],
      );

      expect(stats.races, 2);
      expect(stats.wins, 12);
      // Same race P1+P2 → dedupe keeps best position only.
      expect(stats.podiums, 1);
      expect(stats.poles, 8);
      expect(stats.current, hasLength(1));
      expect(stats.related.first.driverId, 'max_verstappen');
      expect(stats.winRaces, hasLength(1));
      expect(stats.poleRaces.first.driver?.familyName, 'Verstappen');
    });
  });
}
