import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/core/espn/models/espn_scoreboard_models.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';

/// Загрузка ESPN F1 scoreboard (ближайший / текущий уикенд).
abstract class EspnScoreboardLoader {
  static EspnScoreboardEvent? _cache;
  static DateTime? _cachedAt;
  static Future<EspnScoreboardEvent?>? _inFlight;

  /// Последний успешно загруженный event (может быть `null`, если events пуст).
  static EspnScoreboardEvent? get peek => _cache;

  /// Есть ли валидный кэш (включая «пустой» ответ).
  static bool get isFresh =>
      _cachedAt != null && DateTime.now().difference(_cachedAt!) < StaticData.espnScoreboardCacheTtl;

  /// Возвращает первый event из scoreboard или `null`, если список пуст.
  ///
  /// Повторные вызовы в пределах TTL отдают in-memory кэш; параллельные — один запрос.
  static Future<EspnScoreboardEvent?> loadEvent({bool forceRefresh = false}) async {
    if (!forceRefresh && isFresh) {
      return _cache;
    }
    if (_inFlight != null) {
      return _inFlight!;
    }

    final future = _fetchAndCache();
    _inFlight = future;
    try {
      return await future;
    } finally {
      if (identical(_inFlight, future)) {
        _inFlight = null;
      }
    }
  }

  static Future<EspnScoreboardEvent?> _fetchAndCache() async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 20000),
      ),
    );

    final response = await dio.get<Map<String, dynamic>>(StaticData.espnF1ScoreboardUrl);
    final data = response.data;
    if (data == null) {
      throw ResponseParseException('Empty ESPN scoreboard response');
    }

    final rawEvents = data['events'];
    if (rawEvents is! List<dynamic> || rawEvents.isEmpty) {
      _cache = null;
      _cachedAt = DateTime.now();
      return null;
    }

    final first = rawEvents.first;
    if (first is! Map<String, dynamic>) {
      throw ResponseParseException('ESPN scoreboard: invalid event');
    }

    final event = _parseEvent(first);
    _cache = event;
    _cachedAt = DateTime.now();
    return event;
  }

  /// Для тестов.
  static void clearCache() {
    _cache = null;
    _cachedAt = null;
    _inFlight = null;
  }

  static EspnScoreboardEvent _parseEvent(Map<String, dynamic> json) {
    final statusType = _asMap(json['status'])?['type'];
    final statusMap = _asMap(statusType);
    final circuit = _asMap(json['circuit']);
    final address = _asMap(circuit?['address']);

    final competitions = json['competitions'];
    final sessions = <EspnScoreboardSession>[];

    if (competitions is List<dynamic>) {
      for (final raw in competitions.whereType<Map<String, dynamic>>()) {
        sessions.add(_parseSession(raw));
      }
    }

    return EspnScoreboardEvent(
      name: (json['name'] as String?)?.trim() ?? '',
      shortName: (json['shortName'] as String?)?.trim() ?? '',
      statusState: (statusMap?['state'] as String?)?.trim() ?? '',
      statusDetail: _statusDetail(statusMap),
      startDate: _parseDate(json['date'] as String?),
      endDate: _parseDate(json['endDate'] as String?),
      circuitName: (circuit?['fullName'] as String?)?.trim(),
      circuitCity: (address?['city'] as String?)?.trim(),
      circuitCountry: (address?['country'] as String?)?.trim(),
      sessions: sessions,
    );
  }

  static EspnScoreboardSession _parseSession(Map<String, dynamic> json) {
    final type = _asMap(json['type']);
    final statusMap = _asMap(_asMap(json['status'])?['type']);
    final results = _parseResults(json['competitors']);
    final leader = results.isEmpty ? null : results.first;

    final abbreviation = (type?['abbreviation'] as String?)?.trim() ?? '';
    return EspnScoreboardSession(
      abbreviation: abbreviation.isEmpty ? 'Session' : abbreviation,
      statusState: (statusMap?['state'] as String?)?.trim() ?? '',
      statusDetail: _statusDetail(statusMap),
      date: _parseDate(json['date'] as String? ?? json['startDate'] as String?),
      leaderName: leader?.displayName,
      isWinner: leader?.isWinner ?? false,
      results: results,
    );
  }

  static List<EspnScoreboardResultEntry> _parseResults(Object? rawCompetitors) {
    if (rawCompetitors is! List<dynamic>) {
      return const [];
    }

    final entries = <EspnScoreboardResultEntry>[];
    for (final raw in rawCompetitors.whereType<Map<String, dynamic>>()) {
      final athlete = _asMap(raw['athlete']);
      final displayName =
          (athlete?['displayName'] as String?)?.trim() ?? (athlete?['shortName'] as String?)?.trim() ?? '';
      if (displayName.isEmpty) {
        continue;
      }

      final order = raw['order'];
      final position = order is int ? order : int.tryParse('$order') ?? (entries.length + 1);
      final flag = _asMap(athlete?['flag']);
      final country = (flag?['alt'] as String?)?.trim();

      entries.add(
        EspnScoreboardResultEntry(
          position: position,
          displayName: displayName,
          country: country == null || country.isEmpty ? null : country,
          isWinner: raw['winner'] == true,
        ),
      );
    }

    entries.sort((a, b) => a.position.compareTo(b.position));
    return entries;
  }

  static String _statusDetail(Map<String, dynamic>? statusMap) {
    final shortDetail = (statusMap?['shortDetail'] as String?)?.trim();
    if (shortDetail != null && shortDetail.isNotEmpty) {
      return shortDetail;
    }
    final detail = (statusMap?['detail'] as String?)?.trim();
    if (detail != null && detail.isNotEmpty) {
      return detail;
    }
    return (statusMap?['description'] as String?)?.trim() ?? '';
  }

  static DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw)?.toLocal();
  }

  static Map<String, dynamic>? _asMap(Object? value) => value is Map<String, dynamic> ? value : null;
}
