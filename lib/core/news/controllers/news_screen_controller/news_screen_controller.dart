import 'dart:math' as math;

import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'news_screen_controller.g.dart';

/// MobX-контроллер ленты новостей ESPN (Home + общий кэш репозитория).
class NewsScreenController = NewsScreenControllerBase with _$NewsScreenController;

/// Управляет загрузкой и клиентской пагинацией ленты новостей.
abstract class NewsScreenControllerBase with Store {
  NewsScreenControllerBase({
    NewsRepository? newsRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<List<NewsArticleModel>> Function()? fetchArticlesForTest,
  }) : _newsRepository = newsRepository,
       _dataRefresh = dataRefresh,
       _fetchArticlesForTest = fetchArticlesForTest;

  /// Сколько карточек показывать за один «экран» пагинации.
  static const pageSize = 10;

  final NewsRepository? _newsRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<List<NewsArticleModel>> Function()? _fetchArticlesForTest;

  @observable
  AsyncValue<List<NewsArticleModel>> articles = const AsyncValue.loading();

  /// Сколько элементов из [articles] видно в UI (клиентская пагинация).
  @observable
  int visibleCount = pageSize;

  @computed
  CustomException? get screenError => articles.exception;

  /// Уже раскрытая часть ленты.
  @computed
  List<NewsArticleModel> get visibleArticles {
    final list = articles.value;
    if (list == null || list.isEmpty) {
      return const [];
    }
    return list.take(visibleCount).toList(growable: false);
  }

  /// Есть ли ещё элементы за пределами [visibleCount].
  @computed
  bool get canRevealMore {
    final list = articles.value;
    return list != null && visibleCount < list.length;
  }

  /// Подгружает следующую страницу в UI (данные уже в памяти).
  @action
  void revealMore() {
    final list = articles.value;
    if (list == null || visibleCount >= list.length) {
      return;
    }
    visibleCount = math.min(visibleCount + pageSize, list.length);
  }

  /// Загружает новости (сначала кэш, без мигания лоадера при повторном открытии).
  @action
  Future<void> loadArticles({bool forceRefresh = false}) async {
    final newsRepository = _newsRepository;
    final useSharedCache = _fetchArticlesForTest == null && newsRepository != null;
    if (useSharedCache && !forceRefresh) {
      final cached = newsRepository.peek;
      if (newsRepository.isFresh && cached != null) {
        _applyArticles(cached);
        return;
      }
      if (cached != null) {
        _applyArticles(cached);
        try {
          final data = await newsRepository.loadArticles();
          _applyArticles(data, resetPagination: false);
        } on Object {
          // оставляем кэш на экране
        }
        return;
      }
    }

    if (forceRefresh && useSharedCache) {
      try {
        final data = await newsRepository.loadArticles(forceRefresh: true);
        _applyArticles(data);
      } on Object {
        if (!articles.isValue) {
          await runAsyncLoad<List<NewsArticleModel>, List<NewsArticleModel>>(
            fetch: _fetchArticles,
            getField: () => articles,
            setField: (value) => articles = value,
            onSuccess: (data) => _applyArticles(data ?? const []),
          );
        }
      }
      return;
    }

    await runAsyncLoad<List<NewsArticleModel>, List<NewsArticleModel>>(
      fetch: _fetchArticles,
      getField: () => articles,
      setField: (value) => articles = value,
      onSuccess: (data) => _applyArticles(data ?? const []),
    );
  }

  /// Pull-to-refresh: единый сброс кэшей и перезагрузка ленты.
  @action
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await loadArticles(forceRefresh: true);
  }

  void _applyArticles(List<NewsArticleModel> data, {bool resetPagination = true}) {
    articles = articles.toValue(data);
    if (resetPagination) {
      visibleCount = math.min(pageSize, data.length);
      return;
    }
    if (data.isEmpty) {
      visibleCount = 0;
      return;
    }
    visibleCount = visibleCount.clamp(1, data.length);
  }

  Future<List<NewsArticleModel>> _fetchArticles() {
    final forTest = _fetchArticlesForTest;
    if (forTest != null) {
      return forTest();
    }
    return _newsRepository!.loadArticles();
  }
}
