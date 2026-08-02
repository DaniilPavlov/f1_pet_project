import 'package:f1_pet_project/core/predictor/controllers/predictor_screen_controller/predictor_screen_controller.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_lock.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_score_service.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';

void main() {
  group('PredictorScoreService', () {
    test('scores exact position matches', () {
      expect(
        PredictorScoreService.scoreOrders(
          predicted: ['a', 'b', 'c'],
          actualByPosition: ['a', 'x', 'c'],
        ),
        2,
      );
    });

    test('scores zero when nothing matches', () {
      expect(
        PredictorScoreService.scoreOrders(
          predicted: ['a', 'b'],
          actualByPosition: ['b', 'a'],
        ),
        0,
      );
    });
  });

  group('hasUsableDriverCode', () {
    DriverModel driver({String? code}) => DriverModel(
      driverId: 'x',
      url: '',
      givenName: 'A',
      familyName: 'B',
      dateOfBirth: '',
      nationality: '',
      code: code,
      permanentNumber: null,
    );

    test('accepts real codes', () {
      expect(hasUsableDriverCode(driver(code: 'BOT')), isTrue);
      expect(hasUsableDriverCode(driver(code: 'COL')), isTrue);
    });

    test('rejects none / empty', () {
      expect(hasUsableDriverCode(driver(code: 'none')), isFalse);
      expect(hasUsableDriverCode(driver(code: 'NONE')), isFalse);
      expect(hasUsableDriverCode(driver(code: '')), isFalse);
      expect(hasUsableDriverCode(driver()), isFalse);
    });
  });

  group('defaultPredictorOrder', () {
    test('orders by championship then appends missing roster drivers', () {
      expect(
        defaultPredictorOrder(
          rosterIds: const ['a', 'b', 'c', 'd'],
          championshipOrder: const ['c', 'a'],
        ),
        ['c', 'a', 'b', 'd'],
      );
    });

    test('falls back to roster when standings empty', () {
      expect(
        defaultPredictorOrder(
          rosterIds: const ['a', 'b'],
          championshipOrder: const [],
        ),
        ['a', 'b'],
      );
    });
  });

  group('PredictorLock', () {
    RacesModel copyRace({RaceDateModel? qualifying}) {
      final base = ControllerFixtures.race;
      return RacesModel(
        season: base.season,
        round: base.round,
        url: base.url,
        raceName: base.raceName,
        circuit: base.circuit,
        date: base.date,
        time: base.time,
        firstPractice: base.firstPractice,
        secondPractice: base.secondPractice,
        thirdPractice: base.thirdPractice,
        qualifying: qualifying,
        sprint: base.sprint,
        results: base.results,
        qualifyingResults: base.qualifyingResults,
        pitStops: base.pitStops,
      );
    }

    test('locks one hour before qualifying', () {
      final race = copyRace(qualifying: RaceDateModel(date: '2026-05-01', time: '14:00:00Z'));
      final lockAt = PredictorLock.lockAt(race)!;
      expect(PredictorLock.isLocked(race, lockAt.subtract(const Duration(seconds: 1))), isFalse);
      expect(PredictorLock.isLocked(race, lockAt), isTrue);
    });

    test('stays unlocked when qualifying time is missing', () {
      final race = copyRace();
      expect(PredictorLock.lockAt(race), isNull);
      expect(PredictorLock.isLocked(race, DateTime.now()), isFalse);
    });
  });
}
