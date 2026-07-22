import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/news/controllers/news_screen_controller/news_screen_controller.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mobx/mobx_testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const article = NewsArticleModel(
    id: 1,
    headline: 'Test',
    description: 'Desc',
    webUrl: 'https://example.com',
  );

  group('NewsScreenController', () {
    mobxTest(
      'loadArticles sets value on success',
      build: () => NewsScreenController(fetchArticlesForTest: () async => [article]),
      value: (store) => store.articles,
      act: (store) => store.loadArticles(),
      expect: () => [
        isA<AsyncValue<List<NewsArticleModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
        isA<AsyncValue<List<NewsArticleModel>>>()
            .having((e) => e.status, 'status', AsyncStatus.value)
            .having((e) => e.value?.length, 'length', 1),
      ],
    );

    mobxTest(
      'loadArticles sets error on failure',
      build: () => NewsScreenController(
        fetchArticlesForTest: () async => throw ResponseParseException('parse error'),
      ),
      value: (store) => store.articles,
      act: (store) => store.loadArticles(),
      expect: () => [
        isA<AsyncValue<List<NewsArticleModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
        isA<AsyncValue<List<NewsArticleModel>>>().having((e) => e.status, 'status', AsyncStatus.error),
      ],
    );

    test('refreshAll reloads articles via forTest hook', () async {
      var calls = 0;
      final controller = NewsScreenController(
        fetchArticlesForTest: () async {
          calls++;
          return [article];
        },
      );

      await controller.refreshAll();

      expect(calls, 1);
      expect(controller.articles.isValue, isTrue);
      expect(controller.articles.value, hasLength(1));
    });
  });
}
