import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/core/results/h2h/repositories/h2h_repository.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_request_handler.dart';
import '../../../../helpers/jolpica_fixtures.dart';

void main() {
  setUp(CareerApiHelper.resetThrottleForTest);

  FakeRequestHandler configureDriverEntity({required String entityPath}) {
    final handler = FakeRequestHandler(
      resolver: (path, limit, offset) {
        if (path == '$entityPath/results') {
          return JolpicaFixtures.mrDataRaceTable(
            races: [
              JolpicaFixtures.race(
                round: '1',
                results: [JolpicaFixtures.resultEntry(position: '1', points: '25')],
              ),
              JolpicaFixtures.race(
                round: '2',
                raceName: 'Saudi Grand Prix',
                results: [JolpicaFixtures.resultEntry(position: '2', points: '18')],
              ),
            ],
            total: 2,
          );
        }
        if (path == '$entityPath/sprint') {
          return JolpicaFixtures.mrDataRaceTable(
            races: [
              JolpicaFixtures.race(
                round: '1',
                sprintResults: [JolpicaFixtures.resultEntry(position: '1', points: '8')],
              ),
            ],
            total: 1,
          );
        }
        if (path == '$entityPath/qualifying/1') {
          return JolpicaFixtures.mrDataRaceTable(races: const [], total: 4);
        }
        throw StateError('unexpected path $path');
      },
    );
    ApiLoader.configure(handler);
    return handler;
  }

  group('H2hRepository', () {
    test('loadDriverCompareData merges race+sprint points and podium stats', () async {
      configureDriverEntity(entityPath: 'drivers/max_verstappen');

      final data = await const H2hRepository().loadDriverCompareData(driverId: 'max_verstappen');

      expect(data.stats.races, 2);
      expect(data.stats.wins, 1);
      expect(data.stats.podiums, 2); // P1 + P2
      expect(data.stats.poles, 4);
      expect(data.scores, hasLength(2));
      expect(data.scores.first.points, 33); // 25 race + 8 sprint
      expect(data.scores.last.points, 18);
    });

    test('season prefix is applied to paths', () async {
      final handler = configureDriverEntity(entityPath: '2024/drivers/max_verstappen');

      await const H2hRepository().driverStats(driverId: 'max_verstappen', season: '2024');

      expect(
        handler.calls.map((c) => c.path),
        containsAll([
          '2024/drivers/max_verstappen/results',
          '2024/drivers/max_verstappen/sprint',
          '2024/drivers/max_verstappen/qualifying/1',
        ]),
      );
    });

    test('compareDrivers builds timeline for both sides', () async {
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          if (path.endsWith('/results')) {
            final isA = path.contains('max_verstappen');
            return JolpicaFixtures.mrDataRaceTable(
              races: [
                JolpicaFixtures.race(results: [JolpicaFixtures.resultEntry(points: isA ? '25' : '18')]),
              ],
              total: 1,
            );
          }
          if (path.endsWith('/sprint')) {
            return JolpicaFixtures.emptyRaceTable();
          }
          if (path.endsWith('/qualifying/1')) {
            return JolpicaFixtures.mrDataRaceTable(races: const [], total: 0);
          }
          throw StateError(path);
        },
      );
      ApiLoader.configure(handler);

      final compare = await const H2hRepository().compareDrivers(
        driverIdA: 'max_verstappen',
        driverIdB: 'charles_leclerc',
      );

      expect(compare.statsA.wins, 1);
      expect(compare.statsB.wins, 1);
      expect(compare.timeline.points, hasLength(1));
      expect(compare.timeline.points.first.cumulativeA, 25);
      expect(compare.timeline.points.first.cumulativeB, 18);
    });

    test('compareConstructors uses constructors paths', () async {
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          if (path.endsWith('/results')) {
            return JolpicaFixtures.mrDataRaceTable(
              races: [
                JolpicaFixtures.race(results: [JolpicaFixtures.resultEntry(points: '44')]),
              ],
              total: 1,
            );
          }
          if (path.endsWith('/sprint') || path.endsWith('/qualifying/1')) {
            return JolpicaFixtures.emptyRaceTable(total: path.endsWith('/qualifying/1') ? 2 : 0);
          }
          throw StateError(path);
        },
      );
      ApiLoader.configure(handler);

      final compare = await const H2hRepository().compareConstructors(
        constructorIdA: 'red_bull',
        constructorIdB: 'ferrari',
      );

      expect(compare.statsA.races, 1);
      expect(compare.statsB.poles, 2);
      expect(handler.calls.any((c) => c.path == 'constructors/red_bull/results'), isTrue);
      expect(handler.calls.any((c) => c.path == 'constructors/ferrari/results'), isTrue);
    });

    test('stats and roundScores wrappers count podiums including P3', () async {
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          if (path.endsWith('/results')) {
            return JolpicaFixtures.mrDataRaceTable(
              races: [
                JolpicaFixtures.race(
                  results: [
                    JolpicaFixtures.resultEntry(position: '1', points: '25'),
                    JolpicaFixtures.resultEntry(position: '3', points: '15'),
                  ],
                ),
              ],
              total: 1,
            );
          }
          if (path.endsWith('/sprint')) {
            return JolpicaFixtures.emptyRaceTable();
          }
          if (path.endsWith('/qualifying/1')) {
            return JolpicaFixtures.mrDataRaceTable(races: const [], total: 1);
          }
          throw StateError(path);
        },
      );
      ApiLoader.configure(handler);
      const repo = H2hRepository();

      final driverStats = await repo.driverStats(driverId: 'max_verstappen');
      expect(driverStats.wins, 1);
      expect(driverStats.podiums, 2);

      final scores = await repo.driverRoundScores(driverId: 'max_verstappen');
      expect(scores.single.points, 40);

      final ctorStats = await repo.constructorStats(constructorId: 'red_bull');
      expect(ctorStats.races, 1);
      final ctorScores = await repo.constructorRoundScores(constructorId: 'red_bull');
      expect(ctorScores, isNotEmpty);
    });
  });
}
