import 'dart:convert';

import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Простое хранение JSON-карты в SharedPreferences с меткой времени.
class PrefsJsonStore {
  const PrefsJsonStore(this.key);

  final String key;

  Future<({DateTime? cachedAt, Map<String, dynamic> data})?> read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null) {
        return null;
      }
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final data = map['data'];
      if (data is! Map<String, dynamic>) {
        return null;
      }
      return (
        cachedAt: DateTime.tryParse(map['cachedAt'] as String? ?? '')?.toLocal(),
        data: data,
      );
    } on Object catch (error, stackTrace) {
      logger.w('PrefsJsonStore($key).read failed', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> write(Map<String, dynamic> data, {DateTime? cachedAt}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        key,
        jsonEncode(<String, dynamic>{
          'cachedAt': (cachedAt ?? DateTime.now()).toIso8601String(),
          'data': data,
        }),
      );
    } on Object catch (error, stackTrace) {
      logger.w('PrefsJsonStore($key).write failed', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}

/// Дневной JSON-кэш (валиден только в текущий календарный день).
class DayPrefsJsonStore {
  const DayPrefsJsonStore({required this.dataKey, required this.dateKey});

  final String dataKey;
  final String dateKey;

  Future<Map<String, dynamic>?> readToday() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedDate = prefs.getString(dateKey);
    final cachedRaw = prefs.getString(dataKey);
    if (cachedRaw == null || cachedDate != _todayKey()) {
      return null;
    }
    return _decode(cachedRaw);
  }

  /// Любые сохранённые данные (для офлайн-fallback вне «сегодня»).
  Future<Map<String, dynamic>?> readAny() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedRaw = prefs.getString(dataKey);
    if (cachedRaw == null) {
      return null;
    }
    return _decode(cachedRaw);
  }

  Future<void> writeToday(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(dataKey, jsonEncode(data));
    await prefs.setString(dateKey, _todayKey());
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(dataKey);
    await prefs.remove(dateKey);
  }

  Map<String, dynamic>? _decode(String raw) {
    try {
      return Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } on Object catch (error, stackTrace) {
      logger.w('DayPrefsJsonStore($dataKey).decode failed', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  static String _todayKey() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }
}
