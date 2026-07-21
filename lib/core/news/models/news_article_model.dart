import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';

/// Статья новостей ESPN F1.
class NewsArticleModel {
  const NewsArticleModel({
    required this.id,
    required this.headline,
    required this.description,
    required this.webUrl,
    this.byline,
    this.published,
    this.imageUrl,
  });

  final int id;
  final String headline;
  final String description;
  final String webUrl;
  final String? byline;
  final DateTime? published;
  final String? imageUrl;

  /// Парсит статью из ответа ESPN news.
  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    try {
      final links = json['links'];
      final web = links is Map<String, dynamic> ? links['web'] : null;
      final href = web is Map<String, dynamic> ? web['href'] as String? : null;

      String? imageUrl;
      final images = json['images'];
      if (images is List && images.isNotEmpty) {
        final first = images.first;
        if (first is Map<String, dynamic>) {
          imageUrl = first['url'] as String?;
        }
      }

      final publishedRaw = json['published'] as String? ?? json['lastModified'] as String?;
      return NewsArticleModel(
        id: json['id'] as int? ?? 0,
        headline: json['headline'] as String? ?? '',
        description: json['description'] as String? ?? '',
        byline: json['byline'] as String?,
        published: publishedRaw == null ? null : DateTime.tryParse(publishedRaw)?.toLocal(),
        imageUrl: imageUrl,
        webUrl: href ?? '',
      );
    } on Object catch (e) {
      throw ResponseParseException('NewsArticleModel: $e');
    }
  }
}
