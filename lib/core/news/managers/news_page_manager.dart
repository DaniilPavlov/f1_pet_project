import 'dart:math' as math;

import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/core/news/state/state_holders/news_page_state_holder.dart';
import 'package:f1_pet_project/core/news/state/state_models/news_page_view_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';

/// Загрузка и клиентская пагинация ленты новостей ESPN.
class NewsPageManager {
  NewsPageManager({
    required NewsPageStateHolder holder,
    NewsRepository? newsRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<List<NewsArticleModel>> Function()? fetchArticlesForTest,
  }) : _holder = holder,
       _newsRepository = newsRepository,
       _dataRefresh = dataRefresh,
       _fetchArticlesForTest = fetchArticlesForTest;

  /// Сколько карточек показывать за один «экран» пагинации.
  static const pageSize = newsPageSize;

  final NewsPageStateHolder _holder;
  final NewsRepository? _newsRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<List<NewsArticleModel>> Function()? _fetchArticlesForTest;

  /// Подгружает следующую страницу в UI (данные уже в памяти).
  void revealMore() {
    final list = _holder.viewModel.articles.value;
    if (list == null || _holder.viewModel.visibleCount >= list.length) {
      return;
    }
    _holder.setViewModel(
      _holder.viewModel.copyWith(
        visibleCount: math.min(_holder.viewModel.visibleCount + pageSize, list.length),
      ),
    );
  }

  /// Загружает новости (сначала кэш, без мигания лоадера при повторном открытии).
  Future<void> loadArticles({bool forceRefresh = false}) async {
    final newsRepository = _fetchArticlesForTest == null ? _newsRepository : null;
    final useSharedCache = newsRepository != null;
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
        if (!_holder.viewModel.articles.isValue) {
          await runAsyncLoad<List<NewsArticleModel>, List<NewsArticleModel>>(
            fetch: _fetchArticles,
            getField: () => _holder.viewModel.articles,
            setField: (value) => _holder.setViewModel(_holder.viewModel.copyWith(articles: value)),
            onSuccess: (data) => _applyArticles(data ?? const []),
          );
        }
      }
      return;
    }

    await runAsyncLoad<List<NewsArticleModel>, List<NewsArticleModel>>(
      fetch: _fetchArticles,
      getField: () => _holder.viewModel.articles,
      setField: (value) => _holder.setViewModel(_holder.viewModel.copyWith(articles: value)),
      onSuccess: (data) => _applyArticles(data ?? const []),
    );
  }

  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await loadArticles(forceRefresh: true);
  }

  void _applyArticles(List<NewsArticleModel> data, {bool resetPagination = true}) {
    if (resetPagination) {
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          articles: _holder.viewModel.articles.toValue(data),
          visibleCount: math.min(pageSize, data.length),
        ),
      );
      return;
    }
    if (data.isEmpty) {
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          articles: _holder.viewModel.articles.toValue(data),
          visibleCount: 0,
        ),
      );
      return;
    }
    _holder.setViewModel(
      _holder.viewModel.copyWith(
        articles: _holder.viewModel.articles.toValue(data),
        visibleCount: _holder.viewModel.visibleCount.clamp(1, data.length),
      ),
    );
  }

  Future<List<NewsArticleModel>> _fetchArticles() {
    final forTest = _fetchArticlesForTest;
    if (forTest != null) {
      return forTest();
    }
    return _newsRepository!.loadArticles();
  }
}
