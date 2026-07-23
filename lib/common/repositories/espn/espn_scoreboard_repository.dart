import 'dart:async';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/services/cache/prefs_json_store.dart';
import 'package:f1_pet_project/services/http/app_dio.dart';

/// ESPN F1 scoreboard: TTL в памяти + диск, stale-while-revalidate.
class EspnScoreboardRepository {
  EspnScoreboardRepository({Dio? dio, PrefsJsonStore? store})
    : _dio = dio ?? AppDio.external(),
      _store = store ?? const PrefsJsonStore('espn_scoreboard_cache_v1');

  final Dio _dio;
  final PrefsJsonStore _store;

  EspnScoreboardEvent? _cache;
  DateTime? _cachedAt;
  Future<EspnScoreboardEvent?>? _inFlight;
  var _hasValue = false;
  var _diskChecked = false;

  EspnScoreboardEvent? get peek => _cache;

  bool get isFresh =>
      _hasValue &&
      _cachedAt != null &&
      DateTime.now().difference(_cachedAt!) < StaticData.espnScoreboardCacheTtl;

  Future<EspnScoreboardEvent?> loadEvent({bool forceRefresh = false}) async {
    if (!forceRefresh && isFresh) {
      return _cache;
    }
    if (_inFlight != null) {
      return _inFlight!;
    }

    await _ensureDisk();

    if (!forceRefresh && _hasValue) {
      if (!isFresh) {
        unawaited(_refreshSilently());
      }
      return _cache;
    }

    return _runInFlight(_fetch);
  }

  void invalidate() => _cachedAt = null;

  void clearCache() {
    _cache = null;
    _cachedAt = null;
    _inFlight = null;
    _hasValue = false;
    _diskChecked = false;
  }

  Future<void> _ensureDisk() async {
    if (_diskChecked || _hasValue) {
      return;
    }
    _diskChecked = true;
    final stored = await _store.read();
    if (stored == null) {
      return;
    }
    _cache = _eventFrom(stored.data);
    _cachedAt = stored.cachedAt;
    _hasValue = true;
  }

  Future<void> _refreshSilently() async {
    try {
      await _fetch();
    } on Object catch (error, stackTrace) {
      logger.w('EspnScoreboardRepository: silent refresh failed', error: error, stackTrace: stackTrace);
    }
  }

  Future<EspnScoreboardEvent?> _runInFlight(Future<EspnScoreboardEvent?> Function() fetch) async {
    final future = fetch();
    _inFlight = future;
    try {
      return await future;
    } finally {
      if (identical(_inFlight, future)) {
        _inFlight = null;
      }
    }
  }

  Future<EspnScoreboardEvent?> _fetch() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(StaticData.espnF1ScoreboardUrl);
      final data = response.data;
      if (data == null) {
        throw ResponseParseException('Empty ESPN scoreboard response');
      }
      final event = _eventFrom(data);
      _cache = event;
      _cachedAt = DateTime.now();
      _hasValue = true;
      await _store.write(data, cachedAt: _cachedAt);
      return event;
    } on Object {
      if (_hasValue) {
        return _cache;
      }
      await _ensureDisk();
      if (_hasValue) {
        return _cache;
      }
      rethrow;
    }
  }

  EspnScoreboardEvent? _eventFrom(Map<String, dynamic> data) {
    final rawEvents = data['events'];
    if (rawEvents is! List<dynamic> || rawEvents.isEmpty) {
      return null;
    }
    final first = rawEvents.first;
    if (first is! Map<String, dynamic>) {
      throw ResponseParseException('ESPN scoreboard: invalid event');
    }
    return _parseEvent(first);
  }

  EspnScoreboardEvent _parseEvent(Map<String, dynamic> json) {
    // GoF Structural Adapter — чужой JSON ESPN → [EspnScoreboardEvent].
    final statusMap = _asMap(_asMap(json['status'])?['type']);
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

  EspnScoreboardSession _parseSession(Map<String, dynamic> json) {
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

  List<EspnScoreboardResultEntry> _parseResults(Object? rawCompetitors) {
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

  String _statusDetail(Map<String, dynamic>? statusMap) {
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

  DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw)?.toLocal();
  }

  Map<String, dynamic>? _asMap(Object? value) => value is Map<String, dynamic> ? value : null;
}
