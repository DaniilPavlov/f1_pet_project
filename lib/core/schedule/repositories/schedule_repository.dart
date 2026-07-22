import 'dart:convert';

import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Результат загрузки расписания с флагом источника данных.
class ScheduleLoadResult {
  const ScheduleLoadResult({required this.schedule, required this.fetchedFromNetwork});

  final ScheduleModel schedule;
  final bool fetchedFromNetwork;
}

/// Общий кэш расписания текущего сезона (SharedPreferences, не чаще 1 раза в сутки).
class ScheduleRepository {
  ScheduleRepository();

  static const _cacheKey = 'schedule_mr_data';
  static const _cacheDateKey = 'schedule_cache_date';

  Future<ScheduleLoadResult>? _inFlight;

  /// Расписание из дневного prefs-кэша или сети; параллельные вызовы схлопываются через `_inFlight`.
  ///
  /// GoF Structural Proxy — суррогат перед реальной загрузкой: отдаёт prefs-кэш,
  /// схлопывает параллельные вызовы через `_inFlight`, сеть дергает только при необходимости.
  Future<ScheduleLoadResult> getSchedule({bool forceRefresh = false}) {
    if (_inFlight != null) {
      return _inFlight!;
    }

    final future = _load(forceRefresh: forceRefresh);
    _inFlight = future;
    return future.whenComplete(() {
      if (identical(_inFlight, future)) {
        _inFlight = null;
      }
    });
  }

  /// Сбрасывает дневной SharedPreferences-кэш (pull-to-refresh).
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheDateKey);
  }

  Future<ScheduleLoadResult> _load({required bool forceRefresh}) async {
    final prefs = await SharedPreferences.getInstance();

    final today = _dayKey(DateTime.now());
    final cachedDate = prefs.getString(_cacheDateKey);
    final cachedRaw = prefs.getString(_cacheKey);

    final cacheValid = !forceRefresh && cachedRaw != null && cachedDate == today;
    if (cacheValid) {
      return ScheduleLoadResult(
        schedule: ScheduleModel.fromJson(Map<String, dynamic>.from(jsonDecode(cachedRaw) as Map)),
        fetchedFromNetwork: false,
      );
    }

    try {
      final response = await ApiLoader.get('current');
      final mrData = Map<String, dynamic>.from(response.mrData as Map);
      await prefs.setString(_cacheKey, jsonEncode(mrData));
      await prefs.setString(_cacheDateKey, today);
      return ScheduleLoadResult(schedule: ScheduleModel.fromJson(mrData), fetchedFromNetwork: true);
    } on Object catch (error) {
      logger.w('ScheduleRepository: fetch failed, fallback to cache', error: error);
      if (cachedRaw != null) {
        return ScheduleLoadResult(
          schedule: ScheduleModel.fromJson(Map<String, dynamic>.from(jsonDecode(cachedRaw) as Map)),
          fetchedFromNetwork: false,
        );
      }
      rethrow;
    }
  }

  static String _dayKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
