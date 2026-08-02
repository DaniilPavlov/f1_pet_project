import 'package:f1_pet_project/core/predictor/models/predictor_season.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_store.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_repository.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_score_service.dart';
import 'package:f1_pet_project/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthService.mapErrorCode', () {
    test('maps known codes', () {
      expect(AuthService.mapErrorCode('invalid-email'), 'authErrorInvalidEmail');
      expect(AuthService.mapErrorCode('user-disabled'), 'authErrorUserDisabled');
      expect(AuthService.mapErrorCode('user-not-found'), 'authErrorUserNotFound');
      expect(AuthService.mapErrorCode('wrong-password'), 'authErrorWrongPassword');
      expect(AuthService.mapErrorCode('invalid-credential'), 'authErrorInvalidCredential');
      expect(AuthService.mapErrorCode('email-already-in-use'), 'authErrorEmailInUse');
      expect(AuthService.mapErrorCode('weak-password'), 'authErrorWeakPassword');
      expect(AuthService.mapErrorCode('too-many-requests'), 'authErrorTooManyRequests');
      expect(AuthService.mapErrorCode('network-request-failed'), 'authErrorNetwork');
      expect(AuthService.mapErrorCode('unknown-x'), 'authErrorGeneric');
    });
  });

  group('PredictorScoreService actual cache', () {
    test('applyResults stores actual orders', () {
      final weekend = PredictorWeekendPrediction(
        round: '1',
        raceName: 'Test',
        qualifyingOrder: ['a', 'b', 'c'],
        raceOrder: ['a', 'b', 'c'],
      );

      final scored = PredictorScoreService.applyResults(
        weekend: weekend,
        actualQualifyingOrder: ['a', 'x', 'c'],
        actualRaceOrder: ['b', 'a', 'c'],
      );

      expect(scored.qualiPoints, 2);
      expect(scored.racePoints, 1);
      expect(scored.actualQualifyingOrder, ['a', 'x', 'c']);
      expect(scored.actualRaceOrder, ['b', 'a', 'c']);
    });

    test('json roundtrip keeps actual orders', () {
      final weekend = PredictorWeekendPrediction(
        round: '2',
        raceName: 'Spa',
        qualifyingOrder: ['a'],
        raceOrder: ['a'],
        actualQualifyingOrder: ['a'],
        actualRaceOrder: ['b'],
        qualiPoints: 1,
        racePoints: 0,
      );
      final restored = PredictorWeekendPrediction.fromJson(weekend.toJson());
      expect(restored.actualQualifyingOrder, ['a']);
      expect(restored.actualRaceOrder, ['b']);
      expect(restored.qualiPoints, 1);
    });
  });

  group('PredictorRepository.memory', () {
    test('returns empty without uid', () async {
      final repo = PredictorRepository.memory(uidProvider: () => null);
      final store = await repo.load();
      expect(store.seasons, isEmpty);
    });

    test('persists weekend for signed-in uid', () async {
      final repo = PredictorRepository.memory(uidProvider: () => 'uid-1');
      await repo.saveWeekend(
        year: '2026',
        weekend: const PredictorWeekendPrediction(
          round: '1',
          raceName: 'Bahrain',
          qualifyingOrder: ['a', 'b'],
          raceOrder: ['b', 'a'],
        ),
      );
      repo.clearMemoryCache();
      final store = await repo.load();
      final weekend = store.weekend(year: '2026', round: '1');
      expect(weekend?.raceName, 'Bahrain');
      expect(weekend?.qualifyingOrder, ['a', 'b']);
    });

    test('drops in-memory cache when uid becomes null', () async {
      String? uid = 'uid-1';
      final repo = PredictorRepository.memory(uidProvider: () => uid);
      await repo.saveWeekend(
        year: '2026',
        weekend: const PredictorWeekendPrediction(
          round: '1',
          raceName: 'Bahrain',
          qualifyingOrder: ['a'],
          raceOrder: ['a'],
        ),
      );
      expect((await repo.load()).seasons, isNotEmpty);

      uid = null;
      expect((await repo.load()).seasons, isEmpty);
    });

    test('replace persists full store', () async {
      final repo = PredictorRepository.memory(uidProvider: () => 'uid-1');
      final store = PredictorStore(
        seasons: {
          '2026': PredictorSeason(
            year: '2026',
            weekends: {
              '1': const PredictorWeekendPrediction(
                round: '1',
                raceName: 'Bahrain',
                qualifyingOrder: ['a'],
                raceOrder: ['a'],
              ),
            },
          ),
        },
      );
      await repo.replace(store);
      repo.clearMemoryCache();
      final loaded = await repo.load();
      expect(loaded.weekend(year: '2026', round: '1')?.raceName, 'Bahrain');
    });

    test('saveWeekend throws without uid', () async {
      final repo = PredictorRepository.memory(uidProvider: () => null);
      expect(
        () => repo.saveWeekend(
          year: '2026',
          weekend: const PredictorWeekendPrediction(
            round: '1',
            raceName: 'X',
            qualifyingOrder: [],
            raceOrder: [],
          ),
        ),
        throwsStateError,
      );
    });
  });
}
