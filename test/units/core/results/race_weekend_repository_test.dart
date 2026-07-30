import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_request_handler.dart';
import '../../../helpers/jolpica_fixtures.dart';

void main() {
  setUp(CareerApiHelper.resetThrottleForTest);

  group('RaceWeekendRepository', () {
    test('raceResults / seasonRaces load schedule models', () async {
      final handler = FakeRequestHandler(
        responses: {
          '2024/5/results': {
            'MRData': JolpicaFixtures.scheduleMrData(),
          },
          '2024': {
            'MRData': JolpicaFixtures.scheduleMrData(),
          },
        },
      );
      ApiLoader.configure(handler);

      const repo = RaceWeekendRepository();
      final results = await repo.raceResults(year: '2024', round: '5');
      expect(results.raceTable.races, hasLength(1));

      final season = await repo.seasonRaces(year: '2024');
      expect(season.first.raceName, 'Bahrain Grand Prix');
    });

    test('sprint / qualifying / pitStops use wrapped paths', () async {
      final handler = FakeRequestHandler(
        responses: {
          '2024/5/sprint': {'MRData': JolpicaFixtures.scheduleMrData()},
          '2024/5/qualifying': {
            'MRData': JolpicaFixtures.mrDataRaceTable(
              races: [
                JolpicaFixtures.race(
                  qualifyingResults: [JolpicaFixtures.qualifyingEntry()],
                ),
              ],
            )['MRData'],
          },
          '2024/5/pitstops': {'MRData': JolpicaFixtures.scheduleMrData()},
        },
      );
      ApiLoader.configure(handler);
      const repo = RaceWeekendRepository();

      expect((await repo.sprintResults(year: '2024', round: '5')).raceTable.races, isNotEmpty);
      expect((await repo.qualifyingResults(year: '2024', round: '5')).raceTable.races, isNotEmpty);
      expect((await repo.pitStops(year: '2024', round: '5')).raceTable.races, isNotEmpty);

      expect(
        handler.calls.map((c) => c.path),
        containsAll(['2024/5/sprint', '2024/5/qualifying', '2024/5/pitstops']),
      );
    });
  });
}
