import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:f1_pet_project/services/cache/prefs_json_store.dart';

/// Результат загрузки расписания с флагом источника данных.
class ScheduleLoadResult {
  const ScheduleLoadResult({required this.schedule, required this.fetchedFromNetwork});

  final ScheduleModel schedule;
  final bool fetchedFromNetwork;
}

/// Расписание текущего сезона (дневной prefs-кэш + офлайн-fallback).
///
/// GoF Structural Proxy — суррогат перед ApiLoader: отдаёт prefs, схлопывает
/// параллельные вызовы через `_inFlight`, сеть дергает только при необходимости.
class ScheduleRepository {
  ScheduleRepository({DayPrefsJsonStore? store})
    : _store = store ?? const DayPrefsJsonStore(dataKey: 'schedule_mr_data', dateKey: 'schedule_cache_date');

  final DayPrefsJsonStore _store;
  Future<ScheduleLoadResult>? _inFlight;
  var _forceNetwork = false;

  Future<ScheduleLoadResult> getSchedule({bool forceRefresh = false}) {
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

  Future<ScheduleLoadResult> _load({required bool forceRefresh}) async {
    if (!forceRefresh) {
      final today = await _store.readToday();
      if (today != null) {
        return ScheduleLoadResult(schedule: ScheduleModel.fromJson(today), fetchedFromNetwork: false);
      }
    }

    try {
      final response = await ApiLoader.get('current');
      final mrData = Map<String, dynamic>.from(response.mrData as Map);
      await _store.writeToday(mrData);
      return ScheduleLoadResult(schedule: ScheduleModel.fromJson(mrData), fetchedFromNetwork: true);
    } on Object catch (error) {
      logger.w('ScheduleRepository: fetch failed, fallback to cache', error: error);
      final stale = await _store.readAny();
      if (stale != null) {
        return ScheduleLoadResult(schedule: ScheduleModel.fromJson(stale), fetchedFromNetwork: false);
      }
      rethrow;
    }
  }
}
