import 'dart:math' as math;

import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Сколько карточек показывать за один «экран» пагинации.
const newsPageSize = 10;

/// Состояние ленты новостей ESPN.
@immutable
class NewsState {
  const NewsState({
    this.articles = const Loadable.loading(),
    this.visibleCount = newsPageSize,
  });

  final Loadable<List<NewsArticleModel>> articles;

  /// Сколько элементов из [articles] видно в UI (клиентская пагинация).
  final int visibleCount;

  CustomException? get screenError => articles.exception;

  /// Уже раскрытая часть ленты.
  List<NewsArticleModel> get visibleArticles {
    final list = articles.value;
    if (list == null || list.isEmpty) {
      return const [];
    }
    return list.take(visibleCount).toList(growable: false);
  }

  /// Есть ли ещё элементы за пределами [visibleCount].
  bool get canRevealMore {
    final list = articles.value;
    return list != null && visibleCount < list.length;
  }

  NewsState copyWith({
    Loadable<List<NewsArticleModel>>? articles,
    int? visibleCount,
  }) {
    return NewsState(
      articles: articles ?? this.articles,
      visibleCount: visibleCount ?? this.visibleCount,
    );
  }
}

/// Управляет загрузкой и клиентской пагинацией ленты новостей.
class NewsScreenController extends Notifier<NewsState> {
  NewsScreenController({
    @visibleForTesting Future<List<NewsArticleModel>> Function()? fetchArticlesForTest,
  }) : _fetchArticlesForTest = fetchArticlesForTest;

  /// Сколько карточек показывать за один «экран» пагинации.
  static const pageSize = newsPageSize;

  final Future<List<NewsArticleModel>> Function()? _fetchArticlesForTest;

  @override
  NewsState build() => const NewsState();

  /// Подгружает следующую страницу в UI (данные уже в памяти).
  void revealMore() {
    final list = state.articles.value;
    if (list == null || state.visibleCount >= list.length) {
      return;
    }
    state = state.copyWith(visibleCount: math.min(state.visibleCount + pageSize, list.length));
  }

  /// Загружает новости (сначала кэш, без мигания лоадера при повторном открытии).
  Future<void> loadArticles({bool forceRefresh = false}) async {
    final newsRepository = _fetchArticlesForTest == null ? ref.read(newsRepositoryProvider) : null;
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
          if (!ref.mounted) {
            return;
          }
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
        if (!ref.mounted) {
          return;
        }
        _applyArticles(data);
      } on Object {
        if (!state.articles.isValue) {
          await runAsyncLoad<List<NewsArticleModel>, List<NewsArticleModel>>(
            fetch: _fetchArticles,
            getField: () => state.articles,
            setField: (value) => state = state.copyWith(articles: value),
            onSuccess: (data) => _applyArticles(data ?? const []),
          );
        }
      }
      return;
    }

    await runAsyncLoad<List<NewsArticleModel>, List<NewsArticleModel>>(
      fetch: _fetchArticles,
      getField: () => state.articles,
      setField: (value) => state = state.copyWith(articles: value),
      onSuccess: (data) => _applyArticles(data ?? const []),
    );
  }

  /// Pull-to-refresh: единый сброс кэшей и перезагрузка ленты.
  Future<void> refreshAll() async {
    if (_fetchArticlesForTest == null) {
      await ref.read(appDataRefreshProvider).clearAll();
    }
    await loadArticles(forceRefresh: true);
  }

  void _applyArticles(List<NewsArticleModel> data, {bool resetPagination = true}) {
    if (resetPagination) {
      state = state.copyWith(
        articles: state.articles.toValue(data),
        visibleCount: math.min(pageSize, data.length),
      );
      return;
    }
    if (data.isEmpty) {
      state = state.copyWith(articles: state.articles.toValue(data), visibleCount: 0);
      return;
    }
    state = state.copyWith(
      articles: state.articles.toValue(data),
      visibleCount: state.visibleCount.clamp(1, data.length),
    );
  }

  Future<List<NewsArticleModel>> _fetchArticles() {
    final forTest = _fetchArticlesForTest;
    if (forTest != null) {
      return forTest();
    }
    return ref.read(newsRepositoryProvider).loadArticles();
  }
}

final newsScreenControllerProvider = NotifierProvider.autoDispose<NewsScreenController, NewsState>(
  NewsScreenController.new,
);
