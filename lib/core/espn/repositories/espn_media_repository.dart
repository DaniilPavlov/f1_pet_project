import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/core/espn/models/espn_driver_card_data.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/services/http/app_dio.dart';

/// Медиа ESPN для F1: пилоты (search → athlete → overview) и новости команд.
class EspnMediaRepository {
  EspnMediaRepository({Dio? dio}) : _dio = dio ?? AppDio.external();

  final Dio _dio;
  final Map<String, EspnDriverCardData> _driverCardCache = {};
  final Map<String, List<NewsArticleModel>> _constructorNewsCache = {};

  /// Jolpica `constructorId` → ESPN news `team` id.
  static const _teamIdsByConstructorId = <String, String>{
    'mercedes': '106893',
    'ferrari': '106842',
    'mclaren': '106892',
    'red_bull': '106921',
    'alpine': '106922',
    'williams': '106967',
    'aston_martin': '123986',
    'rb': '123988',
    'sauber': '106925',
    'kick_sauber': '106925',
    'audi': '106925',
  };

  /// Нормализованное имя / алиас → ESPN news `team` id.
  static const _teamIdsByAlias = <String, String>{
    'mercedes': '106893',
    'mercedes-benz': '106893',
    'ferrari': '106842',
    'mclaren': '106892',
    'red bull': '106921',
    'alpine': '106922',
    'alpine f1 team': '106922',
    'williams': '106967',
    'aston martin': '123986',
    'racing bulls': '123988',
    'rb': '123988',
    'rb f1 team': '123988',
    'visa cash app rb': '123988',
    'sauber': '106925',
    'kick sauber': '106925',
    'audi': '106925',
  };

  /// Фото, флаг и новости пилота одним проходом (с кэшем).
  Future<EspnDriverCardData> driverCardData({
    required String givenName,
    required String familyName,
  }) async {
    final cacheKey = _normalize('$givenName|$familyName');
    final cached = _driverCardCache[cacheKey];
    if (cached != null) {
      return cached;
    }

    final fullName = '$givenName $familyName'.trim();
    final espnId =
        await _searchF1PlayerId(fullName) ??
        (familyName.trim().isEmpty ? null : await _searchF1PlayerId(familyName.trim()));

    if (espnId == null) {
      const empty = EspnDriverCardData();
      _driverCardCache[cacheKey] = empty;
      return empty;
    }

    final athlete = await _loadAthlete(espnId);
    final news = await _loadDriverNews(espnId);
    final data = EspnDriverCardData(
      photoUrl: athlete,
      news: news,
    );
    _driverCardCache[cacheKey] = data;
    return data;
  }

  /// Только URL фото (для виджетов, которые ещё так вызывают).
  Future<String?> driverPhotoUrl({
    required String givenName,
    required String familyName,
  }) async {
    final data = await driverCardData(givenName: givenName, familyName: familyName);
    return data.photoUrl;
  }

  /// Новости команды (до 5). Ошибка / пусто → `[]`.
  Future<List<NewsArticleModel>> constructorNews({
    required String constructorId,
    required String constructorName,
  }) async {
    final cacheKey = _normalize('$constructorId|$constructorName');
    final cached = _constructorNewsCache[cacheKey];
    if (cached != null) {
      return cached;
    }

    try {
      final teamId = _resolveTeamId(constructorId: constructorId, constructorName: constructorName);
      final news = teamId != null
          ? await _loadNewsByTeamId(teamId)
          : await _loadNewsByTeamNameFallback(constructorName);
      _constructorNewsCache[cacheKey] = news;
      return news;
    } on Object catch (error, stackTrace) {
      logger.e('EspnMediaRepository.constructorNews failed', error: error, stackTrace: stackTrace);
      const empty = <NewsArticleModel>[];
      _constructorNewsCache[cacheKey] = empty;
      return empty;
    }
  }

  String? _resolveTeamId({required String constructorId, required String constructorName}) {
    final byId = _teamIdsByConstructorId[constructorId.trim().toLowerCase()];
    if (byId != null) {
      return byId;
    }

    final name = _normalizeConstructorName(constructorName);
    return _teamIdsByAlias[name] ?? _teamIdsByAlias[_normalize(constructorName)];
  }

  Future<List<NewsArticleModel>> _loadNewsByTeamId(String teamId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      StaticData.espnF1NewsUrl,
      queryParameters: {'team': teamId, 'limit': 5},
    );
    return _parseArticles(response.data?['articles']).take(5).toList();
  }

  /// Если ESPN team id неизвестен — фильтруем общую ленту по названию команды в categories.
  Future<List<NewsArticleModel>> _loadNewsByTeamNameFallback(String constructorName) async {
    final response = await _dio.get<Map<String, dynamic>>(
      StaticData.espnF1NewsUrl,
      queryParameters: {'limit': StaticData.espnF1NewsLimit},
    );
    final needle = _normalizeConstructorName(constructorName);
    if (needle.isEmpty) {
      return const [];
    }

    final raw = response.data?['articles'];
    if (raw is! List<dynamic>) {
      return const [];
    }

    final matched = <NewsArticleModel>[];
    for (final item in raw.whereType<Map<String, dynamic>>()) {
      if (!_articleMentionsTeam(item, needle)) {
        continue;
      }
      final article = NewsArticleModel.fromJson(item);
      if (article.headline.isEmpty || article.webUrl.isEmpty) {
        continue;
      }
      matched.add(article);
      if (matched.length >= 5) {
        break;
      }
    }
    return matched;
  }

  bool _articleMentionsTeam(Map<String, dynamic> json, String needle) {
    final categories = json['categories'];
    if (categories is! List<dynamic>) {
      return false;
    }
    for (final raw in categories.whereType<Map<String, dynamic>>()) {
      if (raw['type'] != 'team') {
        continue;
      }
      final description = _normalizeConstructorName(raw['description'] as String? ?? '');
      if (description.isEmpty) {
        continue;
      }
      if (description == needle || needle.contains(description) || description.contains(needle)) {
        return true;
      }
    }
    return false;
  }

  List<NewsArticleModel> _parseArticles(Object? raw) {
    if (raw is! List<dynamic>) {
      return const [];
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map(NewsArticleModel.fromJson)
        .where((article) => article.headline.isNotEmpty && article.webUrl.isNotEmpty)
        .toList();
  }

  Future<String?> _loadAthlete(String espnId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(StaticData.espnF1AthleteUrl(espnId));
      final data = response.data;
      if (data == null) {
        return null;
      }

      final headshot = data['headshot'];
      if (headshot is Map<String, dynamic>) {
        final href = headshot['href'] as String?;
        final uri = href == null ? null : Uri.tryParse(href);
        if (uri != null && uri.path.isNotEmpty) {
          return StaticData.espnF1DriverPhotoUrl(uri.path);
        }
      }

      return null;
    } on Object catch (error, stackTrace) {
      logger.e('EspnMediaRepository.athlete failed', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  Future<List<NewsArticleModel>> _loadDriverNews(String espnId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        StaticData.espnF1AthleteOverviewUrl(espnId),
        queryParameters: {'region': 'us', 'lang': 'en'},
      );
      return _parseArticles(response.data?['news']).take(5).toList();
    } on Object catch (error, stackTrace) {
      logger.e('EspnMediaRepository.overview failed', error: error, stackTrace: stackTrace);
      return const [];
    }
  }

  Future<String?> _searchF1PlayerId(String query) async {
    if (query.isEmpty) {
      return null;
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        StaticData.espnSearchUrl,
        queryParameters: {
          'region': 'us',
          'lang': 'en',
          'query': query,
          'limit': 10,
          'type': 'player',
        },
      );

      final items = response.data?['items'];
      if (items is! List<dynamic>) {
        return null;
      }

      final normalizedQuery = _normalize(query);
      Map<String, dynamic>? exact;
      Map<String, dynamic>? fallback;

      for (final raw in items.whereType<Map<String, dynamic>>()) {
        final sport = (raw['sport'] as String?)?.toLowerCase();
        final league = (raw['league'] as String?)?.toLowerCase();
        if (sport != 'racing' || league != 'f1') {
          continue;
        }

        fallback ??= raw;
        final name = _normalize(raw['displayName'] as String? ?? '');
        if (name == normalizedQuery || name.contains(normalizedQuery) || normalizedQuery.contains(name)) {
          exact = raw;
          break;
        }
      }

      final match = exact ?? fallback;
      final id = match?['id'];
      if (id == null) {
        return null;
      }
      return id.toString();
    } on Object catch (error, stackTrace) {
      logger.e('EspnMediaRepository.search failed', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  static String _normalize(String value) => value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

  static String _normalizeConstructorName(String value) {
    var name = _normalize(value);
    name = name.replaceAll(RegExp(r'\bf1 team\b'), '').replaceAll(RegExp(r'\bteam\b'), '');
    return name.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Сброс in-memory media-кэша (pull-to-refresh).
  void clearCache() {
    _driverCardCache.clear();
    _constructorNewsCache.clear();
  }
}
