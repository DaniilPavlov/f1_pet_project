import 'dart:async';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/services/cache/prefs_json_store.dart';
import 'package:f1_pet_project/services/http/app_dio.dart';

/// Новости F1 (ESPN): TTL в памяти + диск, stale-while-revalidate.
class NewsRepository {
  NewsRepository({Dio? dio, PrefsJsonStore? store})
    : _dio = dio ??
          AppDio.external(
            connectTimeout: AppDio.connectTimeout,
            receiveTimeout: AppDio.receiveTimeout,
          ),
      _store = store ?? const PrefsJsonStore('espn_news_cache_v1');

  final Dio _dio;
  final PrefsJsonStore _store;

  List<NewsArticleModel>? _cache;
  DateTime? _cachedAt;
  Future<List<NewsArticleModel>>? _inFlight;
  var _diskChecked = false;

  List<NewsArticleModel>? get peek => _cache;

  bool get isFresh =>
      _cache != null &&
      _cachedAt != null &&
      DateTime.now().difference(_cachedAt!) < StaticData.espnNewsCacheTtl;

  Future<List<NewsArticleModel>> loadArticles({bool forceRefresh = false}) async {
    if (!forceRefresh && isFresh) {
      return _cache!;
    }
    if (_inFlight != null) {
      return _inFlight!;
    }

    await _ensureDisk();

    if (!forceRefresh && _cache != null) {
      if (!isFresh) {
        unawaited(_refreshSilently());
      }
      return _cache!;
    }

    return _runInFlight(_fetch);
  }

  void invalidate() => _cachedAt = null;

  void clearCache() {
    _cache = null;
    _cachedAt = null;
    _inFlight = null;
    _diskChecked = false;
  }

  Future<void> _ensureDisk() async {
    if (_diskChecked || _cache != null) {
      return;
    }
    _diskChecked = true;
    final stored = await _store.read();
    if (stored == null) {
      return;
    }
    _cache = _parse(stored.data);
    _cachedAt = stored.cachedAt;
  }

  Future<void> _refreshSilently() async {
    try {
      await _fetch();
    } on Object catch (error, stackTrace) {
      logger.w('NewsRepository: silent refresh failed', error: error, stackTrace: stackTrace);
    }
  }

  Future<List<NewsArticleModel>> _runInFlight(Future<List<NewsArticleModel>> Function() fetch) async {
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

  Future<List<NewsArticleModel>> _fetch() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        StaticData.espnF1NewsUrl,
        queryParameters: {'limit': StaticData.espnF1NewsLimit},
      );
      final data = response.data;
      if (data == null) {
        throw ResponseParseException('Empty ESPN news response');
      }
      final articles = _parse(data);
      _cache = articles;
      _cachedAt = DateTime.now();
      await _store.write(data, cachedAt: _cachedAt);
      return articles;
    } on Object {
      if (_cache != null) {
        return _cache!;
      }
      await _ensureDisk();
      if (_cache != null) {
        return _cache!;
      }
      rethrow;
    }
  }

  List<NewsArticleModel> _parse(Map<String, dynamic> data) {
    final raw = data['articles'];
    if (raw is! List<dynamic>) {
      throw ResponseParseException('ESPN news: articles missing');
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map(NewsArticleModel.fromJson)
        .where((article) => article.headline.isNotEmpty && article.webUrl.isNotEmpty)
        .toList();
  }
}
