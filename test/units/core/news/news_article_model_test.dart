import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NewsArticleModel.fromJson', () {
    test('parses links, image and published', () {
      final article = NewsArticleModel.fromJson({
        'id': 42,
        'headline': 'Title',
        'description': 'Desc',
        'byline': 'ESPN',
        'published': '2024-05-01T12:00:00Z',
        'links': {
          'web': {'href': 'https://www.espn.com/f1/story'},
        },
        'images': [
          {'url': 'http://cdn.espn.com/img.jpg'},
        ],
      });

      expect(article.id, 42);
      expect(article.headline, 'Title');
      expect(article.webUrl, 'https://www.espn.com/f1/story');
      expect(article.imageUrl, 'http://cdn.espn.com/img.jpg');
      expect(article.byline, 'ESPN');
      expect(article.published, isNotNull);
    });

    test('falls back when optional fields missing', () {
      final article = NewsArticleModel.fromJson({'headline': 'Only'});

      expect(article.id, 0);
      expect(article.headline, 'Only');
      expect(article.webUrl, isEmpty);
      expect(article.imageUrl, isNull);
      expect(article.published, isNull);
    });

    test('throws ResponseParseException on invalid types', () {
      expect(
        () => NewsArticleModel.fromJson({'id': 'not-int', 'headline': 'x'}),
        throwsA(isA<ResponseParseException>()),
      );
    });
  });
}
