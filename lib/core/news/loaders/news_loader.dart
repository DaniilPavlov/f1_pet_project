import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';

/// Загрузка новостей F1 из ESPN Site API.
abstract class NewsLoader {
  static List<NewsArticleModel>? _cache;
  static DateTime? _cachedAt;
  static Future<List<NewsArticleModel>>? _inFlight;

  /// Последний успешно загруженный список статей.
  static List<NewsArticleModel>? get peek => _cache;

  /// Есть ли валидный кэш.
  static bool get isFresh =>
      _cache != null &&
      _cachedAt != null &&
      DateTime.now().difference(_cachedAt!) < StaticData.espnNewsCacheTtl;

  /// Возвращает список статей.
  ///
  /// Повторные вызовы в пределах TTL отдают in-memory кэш; параллельные — один запрос.
  static Future<List<NewsArticleModel>> loadArticles({bool forceRefresh = false}) async {
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

  static Future<List<NewsArticleModel>> _fetchAndCache() async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(milliseconds: 20000),
        receiveTimeout: const Duration(milliseconds: 40000),
      ),
    );

    final response = await dio.get<Map<String, dynamic>>(
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

  /// Для тестов.
  static void clearCache() {
    _cache = null;
    _cachedAt = null;
    _inFlight = null;
  }
}
