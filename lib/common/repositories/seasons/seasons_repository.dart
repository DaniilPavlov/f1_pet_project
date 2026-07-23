import 'package:f1_pet_project/common/models/seasons/seasons_model.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:f1_pet_project/services/cache/prefs_json_store.dart';

/// Список сезонов (дневной prefs-кэш + офлайн-fallback).
class SeasonsRepository {
  SeasonsRepository({DayPrefsJsonStore? store})
    : _store = store ?? const DayPrefsJsonStore(dataKey: 'seasons_mr_data', dateKey: 'seasons_cache_date');

  final DayPrefsJsonStore _store;
  Future<List<String>>? _inFlight;
  var _forceNetwork = false;

  Future<List<String>> getSeasonYears({bool forceRefresh = false}) {
    if (_inFlight != null) {
      return _inFlight!;
    }
    final future = _load(forceRefresh: forceRefresh || _forceNetwork);
    _forceNetwork = false;
    _inFlight = future;
    return future.whenComplete(() {
      if (identical(_inFlight, future)) {
        _inFlight = null;
      }
    });
  }

  void invalidate() => _forceNetwork = true;

  Future<void> clearCache() async {
    _forceNetwork = false;
    await _store.clear();
  }

  Future<List<String>> _load({required bool forceRefresh}) async {
    if (!forceRefresh) {
      final today = await _store.readToday();
      if (today != null) {
        return _yearsFrom(today);
      }
    }

    try {
      final response = await ApiLoader.get('seasons');
      final mrData = Map<String, dynamic>.from(response.mrData as Map);
      await _store.writeToday(mrData);
      return _yearsFrom(mrData);
    } on Object catch (error) {
      logger.w('SeasonsRepository: fetch failed, fallback to cache', error: error);
      final stale = await _store.readAny();
      if (stale != null) {
        return _yearsFrom(stale);
      }
      rethrow;
    }
  }

  static List<String> _yearsFrom(Map<String, dynamic> mrData) {
    final years = SeasonsModel.fromJson(mrData).seasonTable.seasons.map((s) => s.season).toList();
    return years.reversed.toList(growable: false);
  }
}
