import 'dart:convert';

import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/core/seasons/models/seasons_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Кэш списка сезонов (SharedPreferences, не чаще 1 раза в сутки).
class SeasonsRepository {
  SeasonsRepository();

  static const _cacheKey = 'seasons_mr_data';
  static const _cacheDateKey = 'seasons_cache_date';

  Future<List<String>>? _inFlight;

  /// Годы сезонов, новые сверху.
  Future<List<String>> getSeasonYears({bool forceRefresh = false}) {
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

  /// Сбрасывает дневной SharedPreferences-кэш.
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheDateKey);
  }

  Future<List<String>> _load({required bool forceRefresh}) async {
    final prefs = await SharedPreferences.getInstance();
    final today = _dayKey(DateTime.now());
    final cachedDate = prefs.getString(_cacheDateKey);
    final cachedRaw = prefs.getString(_cacheKey);

    final cacheValid = !forceRefresh && cachedRaw != null && cachedDate == today;
    if (cacheValid) {
      return _yearsFromMrData(jsonDecode(cachedRaw) as Map<String, dynamic>);
    }

    try {
      final response = await ApiLoader.get('seasons');
      final mrData = Map<String, dynamic>.from(response.mrData as Map);
      await prefs.setString(_cacheKey, jsonEncode(mrData));
      await prefs.setString(_cacheDateKey, today);
      return _yearsFromMrData(mrData);
    } on Object catch (error) {
      logger.w('SeasonsRepository: fetch failed, fallback to cache', error: error);
      if (cachedRaw != null) {
        return _yearsFromMrData(jsonDecode(cachedRaw) as Map<String, dynamic>);
      }
      rethrow;
    }
  }

  static List<String> _yearsFromMrData(Map<String, dynamic> mrData) {
    final model = SeasonsModel.fromJson(mrData);
    final years = model.seasonTable.seasons.map((s) => s.season).toList();
    return years.reversed.toList(growable: false);
  }

  static String _dayKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
