import 'package:f1_pet_project/core/predictor/models/predictor_store.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/services/cache/prefs_json_store.dart';
import 'package:flutter/foundation.dart';

/// Локальное хранилище предсказаний (SharedPreferences, без day-cache).
class PredictorRepository {
  PredictorRepository({PrefsJsonStore? store}) : _store = store ?? const PrefsJsonStore(_prefsKey);

  static const _prefsKey = 'predictor_store_v1';

  final PrefsJsonStore _store;

  PredictorStore? _memory;

  /// Читает store (память → prefs).
  Future<PredictorStore> load() async {
    final cached = _memory;
    if (cached != null) {
      return cached;
    }
    final raw = await _store.read();
    final store = raw == null ? PredictorStore.empty() : PredictorStore.fromJson(raw.data);
    _memory = store;
    return store;
  }

  /// Сохраняет предсказание уикенда.
  Future<PredictorStore> saveWeekend({
    required String year,
    required PredictorWeekendPrediction weekend,
  }) async {
    final current = await load();
    final next = current.upsertWeekend(year: year, weekend: weekend);
    await _persist(next);
    return next;
  }

  /// Полная замена store (для скоринга пачкой).
  Future<PredictorStore> replace(PredictorStore store) async {
    await _persist(store);
    return store;
  }

  @visibleForTesting
  void clearMemoryCache() {
    _memory = null;
  }

  Future<void> _persist(PredictorStore store) async {
    _memory = store;
    await _store.write(store.toJson());
  }
}
