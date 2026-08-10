import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/news/managers/news_page_manager.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/news/providers.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_repositories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const article = NewsArticleModel(id: 1, headline: 'Test', description: 'Desc', webUrl: 'https://example.com');

  group('NewsPageManager', () {
    ProviderContainer createContainer({
      Future<List<NewsArticleModel>> Function()? fetchArticles,
      FakeNewsRepository? newsRepository,
    }) {
      final container = ProviderContainer(
        overrides: [
          if (newsRepository != null) newsRepositoryProvider.overrideWithValue(newsRepository),
          newsPageManagerProvider.overrideWith((ref) {
            return NewsPageManager(
              holder: ref.watch(newsPageStateHolderProvider.notifier),
              newsRepository: newsRepository ??
                  (fetchArticles == null ? ref.watch(newsRepositoryProvider) : null),
              fetchArticlesForTest: fetchArticles,
            );
          }),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('loadArticles sets value on success', () async {
      final container = createContainer(fetchArticles: () async => [article]);
      final manager = container.read(newsPageManagerProvider);

      await manager.loadArticles();

      final state = container.read(newsPageStateHolderProvider);
      expect(state.articles.status, LoadableStatus.value);
      expect(state.articles.value, hasLength(1));
    });

    test('loadArticles sets error on failure', () async {
      final container = createContainer(
        fetchArticles: () async => throw ResponseParseException('parse error'),
      );
      final manager = container.read(newsPageManagerProvider);

      await manager.loadArticles();

      expect(container.read(newsPageStateHolderProvider).articles.status, LoadableStatus.error);
    });

    test('refreshAll reloads articles via forTest hook', () async {
      var calls = 0;
      final container = createContainer(
        fetchArticles: () async {
          calls++;
          return [article];
        },
      );
      final manager = container.read(newsPageManagerProvider);

      await manager.refreshAll();

      final state = container.read(newsPageStateHolderProvider);
      expect(calls, 1);
      expect(state.articles.isValue, isTrue);
      expect(state.articles.value, hasLength(1));
    });

    test('uses shared cache without network when TTL is valid', () async {
      final repo = FakeNewsRepository(articles: [article], isFresh: true);
      final container = createContainer(newsRepository: repo);
      final manager = container.read(newsPageManagerProvider);

      await manager.loadArticles();

      expect(container.read(newsPageStateHolderProvider).articles.value, [article]);
      expect(repo.loadCalls, 0);
    });

    test('shows stale cache then refreshes', () async {
      final updated = [
        article,
        const NewsArticleModel(id: 2, headline: 'Two', description: '', webUrl: 'https://x.com'),
      ];
      final repo = FakeNewsRepository(articles: [article], isFresh: false, next: updated);
      final container = createContainer(newsRepository: repo);
      final manager = container.read(newsPageManagerProvider);

      await manager.loadArticles();

      expect(container.read(newsPageStateHolderProvider).articles.value, updated);
      expect(repo.loadCalls, 1);
    });

    test('stale cache keeps value when refresh fails', () async {
      final repo = FakeNewsRepository(articles: [article], isFresh: false, throwOnLoad: true);
      final container = createContainer(newsRepository: repo);
      final manager = container.read(newsPageManagerProvider);

      await manager.loadArticles();

      expect(container.read(newsPageStateHolderProvider).articles.value, [article]);
      expect(repo.loadCalls, 1);
    });

    test('forceRefresh updates via repository', () async {
      final repo = FakeNewsRepository(
        articles: [article],
        isFresh: true,
        next: [const NewsArticleModel(id: 9, headline: 'New', description: '', webUrl: 'https://x.com')],
      );
      final container = createContainer(newsRepository: repo);
      final manager = container.read(newsPageManagerProvider);

      await manager.loadArticles(forceRefresh: true);

      expect(container.read(newsPageStateHolderProvider).articles.value?.single.id, 9);
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
      final container = createContainer(newsRepository: repo);
      final manager = container.read(newsPageManagerProvider);

      await manager.loadArticles(forceRefresh: true);

      final state = container.read(newsPageStateHolderProvider);
      expect(state.articles.isValue, isTrue);
      expect(state.articles.value, [article]);
    });

    test('screenError exposes CustomException from articles', () async {
      final container = createContainer(
        fetchArticles: () async => throw ResponseParseException('parse error'),
      );
      final manager = container.read(newsPageManagerProvider);

      await manager.loadArticles();

      expect(container.read(newsPageStateHolderProvider).articles.isError, isTrue);
    });

    test('revealMore paginates visible articles', () async {
      final many = List.generate(
        25,
        (i) => NewsArticleModel(id: i, headline: 'H$i', description: '', webUrl: 'https://example.com/$i'),
      );
      final container = createContainer(fetchArticles: () async => many);
      final manager = container.read(newsPageManagerProvider);

      await manager.loadArticles();

      var state = container.read(newsPageStateHolderProvider);
      expect(state.visibleArticles, hasLength(10));
      expect(state.canRevealMore, isTrue);

      manager.revealMore();
      state = container.read(newsPageStateHolderProvider);
      expect(state.visibleArticles, hasLength(20));

      manager
        ..revealMore()
        ..revealMore();
      state = container.read(newsPageStateHolderProvider);
      expect(state.visibleArticles, hasLength(25));
      expect(state.canRevealMore, isFalse);
    });
  });
}
