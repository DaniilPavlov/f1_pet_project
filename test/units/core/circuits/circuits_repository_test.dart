import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_request_handler.dart';
import '../../../helpers/jolpica_fixtures.dart';

void main() {
  setUp(CareerApiHelper.resetThrottleForTest);

  Map<String, dynamic> circuitsMrData([Map<String, dynamic>? circuit]) => {
    'CircuitTable': {
      'Circuits': [circuit ?? JolpicaFixtures.circuitJson],
    },
  };

  group('CircuitsRepository', () {
    test('all and findByCircuitId', () async {
      ApiLoader.configure(
        FakeRequestHandler(
          responses: {
            'circuits': {'MRData': circuitsMrData()},
            'circuits/monaco': {'MRData': circuitsMrData()},
          },
        ),
      );
      const repo = CircuitsRepository();

      final all = await repo.all();
      expect(all.circuitTable.circuits.single.circuitId, 'monaco');

      expect((await repo.findByCircuitId('monaco'))?.circuitName, 'Monaco');
      expect(await repo.findByCircuitId(''), isNull);
    });

    test('winners returns newest first', () async {
      ApiLoader.configure(
        FakeRequestHandler(
          responses: {
            'circuits/monaco/results/1': {
              'MRData': JolpicaFixtures.mrDataRaceTable(
                races: [
                  JolpicaFixtures.race(
                    season: '2023',
                    round: '8',
                    raceName: 'Monaco 2023',
                    results: [JolpicaFixtures.resultEntry()],
                  ),
                  JolpicaFixtures.race(
                    season: '2024',
                    round: '8',
                    raceName: 'Monaco 2024',
                    results: [JolpicaFixtures.resultEntry()],
                  ),
                ],
                total: 2,
              )['MRData'],
            },
          },
        ),
      );

      final wins = await const CircuitsRepository().winners(circuitId: 'monaco');
      expect(wins.map((w) => w.season), ['2024', '2023']);
      expect(wins.first.driverFullName, 'Max Verstappen');
    });

    test('findByCircuitId returns null on failure', () async {
      ApiLoader.configure(
        FakeRequestHandler(resolver: (path, limit, offset) => throw Exception('down')),
      );

      expect(await const CircuitsRepository().findByCircuitId('spa'), isNull);
    });
  });
}
