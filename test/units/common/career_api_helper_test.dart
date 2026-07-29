import 'package:f1_pet_project/common/models/career/career_race_result.dart';
import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/fake_request_handler.dart';
import '../../helpers/jolpica_fixtures.dart';

void main() {
  setUp(CareerApiHelper.resetThrottleForTest);

  group('CareerApiHelper.totalOf', () {
    test('reads int and string totals', () {
      expect(CareerApiHelper.totalOf(const BaseResponseModel(mrData: {'total': 42})), 42);
      expect(CareerApiHelper.totalOf(const BaseResponseModel(mrData: {'total': '7'})), 7);
      expect(CareerApiHelper.totalOf(const BaseResponseModel(mrData: 'broken')), 0);
    });
  });

  group('CareerApiHelper.uniqueRaceCountAcross', () {
    test('counts unique season-round pairs and skips broken pages', () {
      final pages = [
        BaseResponseModel.fromJson(
          JolpicaFixtures.mrDataRaceTable(
            races: [
              JolpicaFixtures.race(round: '1', results: [JolpicaFixtures.resultEntry()]),
              JolpicaFixtures.race(round: '2', raceName: 'Saudi', results: [JolpicaFixtures.resultEntry()]),
            ],
            total: 2,
          ),
        ),
        BaseResponseModel.fromJson(
          JolpicaFixtures.mrDataRaceTable(
            races: [
              JolpicaFixtures.race(round: '2', raceName: 'Saudi', results: [JolpicaFixtures.resultEntry()]),
            ],
            total: 1,
          ),
        ),
        const BaseResponseModel(mrData: {'RaceTable': 'broken'}),
      ];

      expect(CareerApiHelper.uniqueRaceCountAcross(pages), 2);
    });
  });

  group('CareerApiHelper.dedupeByBestPosition', () {
    test('keeps best (lowest) position per race', () {
      final circuit = ControllerFixtures.circuit;
      final constructor = ControllerFixtures.constructor;
      final races = [
        CareerRaceResult(
          season: '2024',
          round: '1',
          raceName: 'Bahrain',
          position: 2,
          constructor: constructor,
          circuit: circuit,
        ),
        CareerRaceResult(
          season: '2024',
          round: '1',
          raceName: 'Bahrain',
          position: 1,
          constructor: constructor,
          circuit: circuit,
        ),
        CareerRaceResult(
          season: '2024',
          round: '2',
          raceName: 'Saudi',
          position: 3,
          constructor: constructor,
          circuit: circuit,
        ),
      ];

      final deduped = CareerApiHelper.dedupeByBestPosition(races);
      expect(deduped, hasLength(2));
      expect(deduped.firstWhere((r) => r.round == '1').position, 1);
    });
  });

  group('CareerApiHelper.parseTableEntities', () {
    test('parses Drivers list and returns empty on bad shape', () {
      final response = BaseResponseModel.fromJson(
        JolpicaFixtures.mrDataDriverTable(drivers: [JolpicaFixtures.driverJson]),
      );

      final drivers = CareerApiHelper.parseTableEntities(
        response: response,
        tableKey: 'DriverTable',
        listKey: 'Drivers',
        fromJson: DriverModel.fromJson,
      );

      expect(drivers, hasLength(1));
      expect(drivers.first.driverId, 'max_verstappen');

      expect(
        CareerApiHelper.parseTableEntities(
          response: const BaseResponseModel(mrData: 'x'),
          tableKey: 'DriverTable',
          listKey: 'Drivers',
          fromJson: DriverModel.fromJson,
        ),
        isEmpty,
      );
    });
  });

  group('CareerApiHelper.fetchAllPages / getThrottled', () {
    test('paginates until offset covers total', () async {
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          expect(path, 'drivers/max_verstappen/results');
          if (offset == 0) {
            return JolpicaFixtures.mrDataRaceTable(
              races: [
                JolpicaFixtures.race(round: '1', results: [JolpicaFixtures.resultEntry()]),
              ],
              total: 2,
            );
          }
          if (offset == 1) {
            return JolpicaFixtures.mrDataRaceTable(
              races: [
                JolpicaFixtures.race(round: '2', raceName: 'Saudi', results: [JolpicaFixtures.resultEntry()]),
              ],
              total: 2,
            );
          }
          return JolpicaFixtures.emptyRaceTable();
        },
      );
      ApiLoader.configure(handler);

      final pages = await CareerApiHelper.fetchAllPages('drivers/max_verstappen/results', pageSize: 1);

      expect(pages, hasLength(2));
      expect(handler.calls.map((c) => c.offset), [0, 1]);
    });

    test('getThrottled uses per-path limits', () async {
      final handler = FakeRequestHandler(
        responses: {'a': JolpicaFixtures.emptyRaceTable(total: 5), 'b': JolpicaFixtures.emptyRaceTable(total: 9)},
      );
      ApiLoader.configure(handler);

      final responses = await CareerApiHelper.getThrottled(['a', 'b'], limits: [1, 3]);

      expect(responses, hasLength(2));
      expect(handler.calls.map((c) => c.limit), [1, 3]);
    });
  });
}
