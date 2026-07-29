import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/core/results/repositories/results_repository.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_request_handler.dart';
import '../../../helpers/jolpica_fixtures.dart';

void main() {
  setUp(CareerApiHelper.resetThrottleForTest);

  group('ResultsRepository', () {
    test('lastRace parses schedule model', () async {
      final handler = FakeRequestHandler(
        responses: {
          'current/last/results': JolpicaFixtures.mrDataRaceTable(
            races: [JolpicaFixtures.race(results: [JolpicaFixtures.resultEntry()])],
          ),
        },
      );
      ApiLoader.configure(handler);

      final model = await const ResultsRepository().lastRace();

      expect(model.raceTable.races, hasLength(1));
      expect(model.raceTable.races.first.results, isNotEmpty);
      expect(handler.calls.single.path, 'current/last/results');
    });
  });
}
