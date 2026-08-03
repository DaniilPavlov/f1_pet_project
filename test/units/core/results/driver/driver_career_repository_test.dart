import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_career_repository.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_request_handler.dart';
import '../../../../helpers/jolpica_fixtures.dart';

void main() {
  setUp(CareerApiHelper.resetThrottleForTest);

  group('DriverCareerRepository', () {
    test('load aggregates totals and race lists', () async {
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          if (path == 'drivers/max_verstappen/results' && limit == 1) {
            return JolpicaFixtures.emptyRaceTable(total: 100);
          }
          if (path == 'drivers/max_verstappen/results/1' && limit == 1 && offset == 0) {
            // totals probe for wins
            return JolpicaFixtures.mrDataRaceTable(races: const [], total: 20);
          }
          if (path == 'drivers/max_verstappen/results/2' && limit == 1) {
            return JolpicaFixtures.mrDataRaceTable(races: const [], total: 10);
          }
          if (path == 'drivers/max_verstappen/results/3' && limit == 1) {
            return JolpicaFixtures.mrDataRaceTable(races: const [], total: 5);
          }
          if (path == 'drivers/max_verstappen/qualifying/1' && limit == 1) {
            return JolpicaFixtures.mrDataRaceTable(races: const [], total: 15);
          }
          if (path == 'drivers/max_verstappen/constructors') {
            return JolpicaFixtures.mrDataConstructorTable(
              constructors: [JolpicaFixtures.constructorJson],
            );
          }
          if (path == 'drivers/max_verstappen/results/1') {
            return JolpicaFixtures.mrDataRaceTable(
              races: [
                JolpicaFixtures.race(
                  season: '2024',
                  round: '2',
                  raceName: 'Saudi',
                  results: [JolpicaFixtures.resultEntry(position: '1')],
                ),
                JolpicaFixtures.race(
                  season: '2023',
                  round: '1',
                  raceName: 'Bahrain',
                  results: [JolpicaFixtures.resultEntry(position: '1')],
                ),
              ],
              total: 2,
            );
          }
          if (path == 'drivers/max_verstappen/results/2' ||
              path == 'drivers/max_verstappen/results/3') {
            return JolpicaFixtures.emptyRaceTable();
          }
          if (path == 'drivers/max_verstappen/qualifying/1') {
            return JolpicaFixtures.mrDataRaceTable(
              races: [
                JolpicaFixtures.race(
                  qualifyingResults: [JolpicaFixtures.qualifyingEntry()],
                ),
              ],
              total: 1,
            );
          }
          throw StateError('unexpected $path limit=$limit offset=$offset');
        },
      );
      ApiLoader.configure(handler);

      final stats = await const DriverCareerRepository().load(
        driverId: 'max_verstappen',
        current: [ControllerFixtures.constructor],
      );

      expect(stats.races, 100);
      expect(stats.wins, 20);
      expect(stats.podiums, 35); // 20+10+5
      expect(stats.poles, 15);
      expect(stats.current, hasLength(1));
      expect(stats.related.first.constructorId, 'red_bull');
      expect(stats.winRaces, hasLength(2));
      expect(stats.winRaces.first.season, '2024'); // newest first
      expect(stats.poleRaces, hasLength(1));
      expect(stats.listsComplete, isTrue);
    });

    test('loadTotals returns incomplete lists then loadRaceLists completes', () async {
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          if (path == 'drivers/max_verstappen/results' && limit == 1) {
            return JolpicaFixtures.emptyRaceTable(total: 100);
          }
          if (path == 'drivers/max_verstappen/results/1' && limit == 1 && offset == 0) {
            return JolpicaFixtures.mrDataRaceTable(races: const [], total: 1);
          }
          if (path == 'drivers/max_verstappen/results/2' && limit == 1) {
            return JolpicaFixtures.mrDataRaceTable(races: const [], total: 0);
          }
          if (path == 'drivers/max_verstappen/results/3' && limit == 1) {
            return JolpicaFixtures.mrDataRaceTable(races: const [], total: 0);
          }
          if (path == 'drivers/max_verstappen/qualifying/1' && limit == 1) {
            return JolpicaFixtures.mrDataRaceTable(races: const [], total: 0);
          }
          if (path == 'drivers/max_verstappen/constructors') {
            return JolpicaFixtures.mrDataConstructorTable(
              constructors: [JolpicaFixtures.constructorJson],
            );
          }
          if (path == 'drivers/max_verstappen/results/1') {
            return JolpicaFixtures.mrDataRaceTable(
              races: [
                JolpicaFixtures.race(
                  season: '2024',
                  round: '2',
                  raceName: 'Saudi',
                  results: [JolpicaFixtures.resultEntry(position: '1')],
                ),
              ],
              total: 1,
            );
          }
          if (path == 'drivers/max_verstappen/results/2' ||
              path == 'drivers/max_verstappen/results/3' ||
              path == 'drivers/max_verstappen/qualifying/1') {
            return JolpicaFixtures.emptyRaceTable();
          }
          throw StateError('unexpected $path limit=$limit offset=$offset');
        },
      );
      ApiLoader.configure(handler);

      final repo = const DriverCareerRepository();
      final totals = await repo.loadTotals(driverId: 'max_verstappen');
      expect(totals.listsComplete, isFalse);
      expect(totals.winRaces, isEmpty);
      expect(totals.wins, 1);

      final complete = await repo.loadRaceLists(driverId: 'max_verstappen', totals: totals);
      expect(complete.listsComplete, isTrue);
      expect(complete.winRaces, hasLength(1));
    });
  });
}
