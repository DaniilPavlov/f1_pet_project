import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:flutter/foundation.dart';

/// Lead-изображение статьи Wikipedia через `prop=pageimages`.
abstract class WikipediaPageImageLoader {
  static final Map<String, String?> _cache = {};
  static final Map<String, Future<String?>> _inFlight = {};

  /// Возвращает URL thumbnail или `null`, если картинки нет / ошибка.
  static Future<String?> loadThumbnail({
    required String articleUrl,
    int thumbSize = 800,
  }) async {
    final parsed = _parseArticle(articleUrl);
    if (parsed == null) {
      return null;
    }
    final cacheKey = '${parsed.host}|${parsed.title}|$thumbSize';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey];
    }
    final existing = _inFlight[cacheKey];
    if (existing != null) {
      return existing;
    }

    final future = _fetch(parsed.host, parsed.title, thumbSize);
    _inFlight[cacheKey] = future;
    try {
      final url = await future;
      _cache[cacheKey] = url;
      return url;
    } finally {
      final removed = _inFlight.remove(cacheKey);
      assert(removed == null || identical(removed, future));
    }
  }

  static Future<String?> _fetch(String host, String title, int thumbSize) async {
    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(milliseconds: 15000),
          receiveTimeout: const Duration(milliseconds: 20000),
          headers: {'User-Agent': StaticData.wikipediaUserAgent},
        ),
      );
      final response = await dio.get<Map<String, dynamic>>(
        'https://$host/w/api.php',
        queryParameters: {
          'action': 'query',
          'titles': title,
          'prop': 'pageimages',
          'format': 'json',
          'piprop': 'thumbnail',
          'pithumbsize': thumbSize,
          'redirects': 1,
        },
      );
      final data = response.data;
      final query = data?['query'];
      if (query is! Map) {
        return null;
      }
      final pages = query['pages'];
      if (pages is! Map) {
        return null;
      }
      for (final page in pages.values) {
        if (page is! Map) {
          continue;
        }
        final thumb = page['thumbnail'];
        if (thumb is Map) {
          final source = thumb['source'];
          if (source is String && source.isNotEmpty) {
            return source;
          }
        }
      }
      return null;
    } on Object catch (error, stackTrace) {
      debugPrint('WikipediaPageImageLoader failed: $error\n$stackTrace');
      return null;
    }
  }

  static ({String host, String title})? _parseArticle(String rawUrl) {
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(trimmed);
    if (uri == null || uri.host.isEmpty) {
      return null;
    }
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    final wikiIndex = segments.indexOf('wiki');
    if (wikiIndex < 0 || wikiIndex >= segments.length - 1) {
      return null;
    }
    final title = Uri.decodeComponent(segments.sublist(wikiIndex + 1).join('/'));
    if (title.isEmpty) {
      return null;
    }
    return (host: uri.host, title: title);
  }

  /// Для тестов.
  static void clearCache() {
    _cache.clear();
    _inFlight.clear();
  }
}
