import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/news/controllers/news_screen_controller/news_screen_controller.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../mobx/mobx_testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const article = NewsArticleModel(id: 1, headline: 'Test', description: 'Desc', webUrl: 'https://example.com');

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
      build: () => NewsScreenController(fetchArticlesForTest: () async => throw ResponseParseException('parse error')),
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

    test('uses fresh shared cache without network', () async {
      final repo = FakeNewsRepository(articles: [article], isFresh: true);
      final controller = NewsScreenController(newsRepository: repo);

      await controller.loadArticles();

      expect(controller.articles.value, [article]);
      expect(repo.loadCalls, 0);
    });

    test('shows stale cache then refreshes', () async {
      final updated = [
        article,
        const NewsArticleModel(id: 2, headline: 'Two', description: '', webUrl: 'https://x.com'),
      ];
      final repo = FakeNewsRepository(articles: [article], isFresh: false, next: updated);
      final controller = NewsScreenController(newsRepository: repo);

      await controller.loadArticles();

      expect(controller.articles.value, updated);
      expect(repo.loadCalls, 1);
    });

    test('stale cache keeps value when refresh fails', () async {
      final repo = FakeNewsRepository(articles: [article], isFresh: false, throwOnLoad: true);
      final controller = NewsScreenController(newsRepository: repo);

      await controller.loadArticles();

      expect(controller.articles.value, [article]);
      expect(repo.loadCalls, 1);
    });

    test('forceRefresh updates via repository', () async {
      final repo = FakeNewsRepository(
        articles: [article],
        isFresh: true,
        next: [const NewsArticleModel(id: 9, headline: 'New', description: '', webUrl: 'https://x.com')],
      );
      final controller = NewsScreenController(newsRepository: repo);

      await controller.loadArticles(forceRefresh: true);

      expect(controller.articles.value?.single.id, 9);
      expect(repo.lastForceRefresh, isTrue);
    });

    test('forceRefresh failure falls back to runAsyncLoad', () async {
      final repo = FakeNewsRepository(
        articles: [article],
        isFresh: true,
        throwOnLoad: true,
        throwOnlyForceRefresh: true,
        next: [article],
      );
      final controller = NewsScreenController(newsRepository: repo);

      await controller.loadArticles(forceRefresh: true);

      // First forceRefresh throws; fallback _fetchArticles succeeds without force.
      expect(controller.articles.isValue, isTrue);
      expect(controller.articles.value, [article]);
    });

    test('screenError exposes CustomException from articles', () async {
      final controller = NewsScreenController(
        fetchArticlesForTest: () async => throw ResponseParseException('parse error'),
      );

      await controller.loadArticles();

      expect(controller.articles.isError, isTrue);
    });
  });
}
