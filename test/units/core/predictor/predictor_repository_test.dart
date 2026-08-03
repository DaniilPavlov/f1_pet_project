import 'package:f1_pet_project/core/predictor/models/predictor_season.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_store.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_repository.dart';
import 'package:flutter_test/flutter_test.dart';

PredictorWeekendPrediction _weekend({
  required String round,
  required String raceName,
  List<String> order = const ['a', 'b'],
}) {
  return PredictorWeekendPrediction(
    round: round,
    raceName: raceName,
    qualifyingOrder: order,
    raceOrder: order,
  );
}

void main() {
  group('PredictorRepository.memory', () {
    test('cache hit returns same store for same uid without backend re-read', () async {
      final repo = PredictorRepository.memory(uidProvider: () => 'uid-1');
      await repo.saveWeekend(year: '2026', weekend: _weekend(round: '1', raceName: 'Bahrain'));

      final first = await repo.load();
      final second = await repo.load();
      expect(identical(first, second), isTrue);
    });

    test('uid change drops cache and loads other user backend', () async {
      String? uid = 'uid-1';
      final repo = PredictorRepository.memory(uidProvider: () => uid);
      await repo.saveWeekend(year: '2026', weekend: _weekend(round: '1', raceName: 'Bahrain'));

      uid = 'uid-2';
      expect((await repo.load()).seasons, isEmpty);

      await repo.saveWeekend(year: '2026', weekend: _weekend(round: '1', raceName: 'Jeddah'));
      expect((await repo.load()).weekend(year: '2026', round: '1')?.raceName, 'Jeddah');

      uid = 'uid-1';
      repo.clearMemoryCache();
      expect((await repo.load()).weekend(year: '2026', round: '1')?.raceName, 'Bahrain');
    });

    test('saveWeekend upserts second weekend and overwrites same round', () async {
      final repo = PredictorRepository.memory(uidProvider: () => 'uid-1');
      await repo.saveWeekend(year: '2026', weekend: _weekend(round: '1', raceName: 'Bahrain'));
      await repo.saveWeekend(year: '2026', weekend: _weekend(round: '2', raceName: 'Jeddah'));
      await repo.saveWeekend(
        year: '2026',
        weekend: _weekend(round: '1', raceName: 'Bahrain GP', order: ['b', 'a']),
      );

      repo.clearMemoryCache();
      final store = await repo.load();
      expect(store.season('2026')?.weekends.keys.toSet(), {'1', '2'});
      expect(store.weekend(year: '2026', round: '1')?.raceName, 'Bahrain GP');
      expect(store.weekend(year: '2026', round: '1')?.qualifyingOrder, ['b', 'a']);
      expect(store.weekend(year: '2026', round: '2')?.raceName, 'Jeddah');
    });

    test('replace persists multi-season store and survives clearMemoryCache', () async {
      final repo = PredictorRepository.memory(uidProvider: () => 'uid-1');
      final store = PredictorStore(
        seasons: {
          '2025': PredictorSeason(
            year: '2025',
            weekends: {'1': _weekend(round: '1', raceName: 'Bahrain 25')},
          ),
          '2026': PredictorSeason(
            year: '2026',
            weekends: {'3': _weekend(round: '3', raceName: 'Australia')},
          ),
        },
      );

      await repo.replace(store);
      repo.clearMemoryCache();
      final loaded = await repo.load();
      expect(loaded.weekend(year: '2025', round: '1')?.raceName, 'Bahrain 25');
      expect(loaded.weekend(year: '2026', round: '3')?.raceName, 'Australia');
    });

    test('replace throws without uid', () async {
      final repo = PredictorRepository.memory(uidProvider: () => null);
      expect(
        () => repo.replace(PredictorStore.empty()),
        throwsStateError,
      );
    });

    test('clearMemoryCache forces backend re-read', () async {
      final repo = PredictorRepository.memory(uidProvider: () => 'uid-1');
      await repo.saveWeekend(year: '2026', weekend: _weekend(round: '1', raceName: 'Bahrain'));
      final cached = await repo.load();
      repo.clearMemoryCache();
      final reloaded = await repo.load();
      expect(identical(cached, reloaded), isFalse);
      expect(reloaded.weekend(year: '2026', round: '1')?.raceName, 'Bahrain');
    });
  });
}
