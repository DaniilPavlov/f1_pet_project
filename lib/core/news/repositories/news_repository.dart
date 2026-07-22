import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/services/http/app_dio.dart';

/// Новости F1 (ESPN Site API) с TTL-кэшем.
class NewsRepository {
  NewsRepository({Dio? dio})
    : _dio = dio ??
          AppDio.external(
            connectTimeout: AppDio.connectTimeout,
            receiveTimeout: AppDio.receiveTimeout,
          );

  final Dio _dio;
  List<NewsArticleModel>? _cache;
  DateTime? _cachedAt;
  Future<List<NewsArticleModel>>? _inFlight;

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

  Future<List<NewsArticleModel>> _fetchAndCache() async {
    final response = await _dio.get<Map<String, dynamic>>(
      StaticData.espnF1NewsUrl,
      queryParameters: {'limit': StaticData.espnF1NewsLimit},
    );
    final data = response.data;
    if (data == null) {
      throw ResponseParseException('Empty ESPN news response');
    }

    final raw = data['articles'];
    if (raw is! List<dynamic>) {
      throw ResponseParseException('ESPN news: articles missing');
    }

    final articles = raw
        .whereType<Map<String, dynamic>>()
        .map(NewsArticleModel.fromJson)
        .where((article) => article.headline.isNotEmpty && article.webUrl.isNotEmpty)
        .toList();

    _cache = articles;
    _cachedAt = DateTime.now();
    return articles;
  }

  void clearCache() {
    _cache = null;
    _cachedAt = null;
    _inFlight = null;
  }
}
