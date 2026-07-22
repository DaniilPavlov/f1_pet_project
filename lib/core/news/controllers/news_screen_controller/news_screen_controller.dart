import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'news_screen_controller.g.dart';

/// MobX-контроллер экрана новостей.
class NewsScreenController = NewsScreenControllerBase with _$NewsScreenController;

/// Управляет загрузкой ленты новостей ESPN F1.
abstract class NewsScreenControllerBase with Store {
  NewsScreenControllerBase({
    NewsRepository? newsRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<List<NewsArticleModel>> Function()? fetchArticlesForTest,
  }) : _newsRepository = newsRepository,
       _dataRefresh = dataRefresh,
       _fetchArticlesForTest = fetchArticlesForTest;

  final NewsRepository? _newsRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<List<NewsArticleModel>> Function()? _fetchArticlesForTest;

  @observable
  AsyncValue<List<NewsArticleModel>> articles = const AsyncValue.loading();

  @computed
  CustomException? get screenError => articles.exception;

  /// Загружает новости (сначала кэш, без мигания лоадера при повторном открытии).
  @action
  Future<void> loadArticles({bool forceRefresh = false}) async {
    final newsRepository = _newsRepository;
    final useSharedCache = _fetchArticlesForTest == null && newsRepository != null;
    if (useSharedCache && !forceRefresh) {
      final cached = newsRepository.peek;
      if (newsRepository.isFresh && cached != null) {
        articles = articles.toValue(cached);
        return;
      }
      if (cached != null) {
        articles = articles.toValue(cached);
        try {
          final data = await newsRepository.loadArticles();
          articles = articles.toValue(data);
        } on Object {
          // оставляем кэш на экране
        }
        return;
      }
    }

    if (forceRefresh && useSharedCache) {
      try {
        final data = await newsRepository.loadArticles(forceRefresh: true);
        articles = articles.toValue(data);
      } on Object {
        if (!articles.isValue) {
          await runAsyncLoad<List<NewsArticleModel>, List<NewsArticleModel>>(
            fetch: _fetchArticles,
            getField: () => articles,
            setField: (value) => articles = value,
            onSuccess: (data) => articles = articles.toValue(data ?? const []),
          );
        }
      }
      return;
    }

    await runAsyncLoad<List<NewsArticleModel>, List<NewsArticleModel>>(
      fetch: _fetchArticles,
      getField: () => articles,
      setField: (value) => articles = value,
      onSuccess: (data) => articles = articles.toValue(data ?? const []),
    );
  }

  /// Pull-to-refresh: единый сброс кэшей и перезагрузка ленты.
  @action
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await loadArticles(forceRefresh: true);
  }

  Future<List<NewsArticleModel>> _fetchArticles() {
    final forTest = _fetchArticlesForTest;
    if (forTest != null) {
      return forTest();
    }
    return _newsRepository!.loadArticles();
  }
}
