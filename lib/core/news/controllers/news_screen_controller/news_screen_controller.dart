import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/news/loaders/news_loader.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:mobx/mobx.dart';

part 'news_screen_controller.g.dart';

/// MobX-контроллер экрана новостей.
class NewsScreenController = NewsScreenControllerBase with _$NewsScreenController;

/// Управляет загрузкой ленты новостей ESPN F1.
abstract class NewsScreenControllerBase with Store {
  NewsScreenControllerBase({Future<List<NewsArticleModel>> Function()? fetchArticles})
    : _fetchArticlesOverride = fetchArticles;

  final Future<List<NewsArticleModel>> Function()? _fetchArticlesOverride;

  @observable
  AsyncValue<List<NewsArticleModel>> articles = const AsyncValue.loading();

  @computed
  CustomException? get screenError => articles.exception;

  /// Загружает новости (сначала кэш, без мигания лоадера при повторном открытии).
  @action
  Future<void> loadArticles({bool forceRefresh = false}) async {
    final useSharedCache = _fetchArticlesOverride == null;
    if (useSharedCache && !forceRefresh) {
      final cached = NewsLoader.peek;
      if (NewsLoader.isFresh && cached != null) {
        articles = articles.toValue(cached);
        return;
      }
      if (cached != null) {
        articles = articles.toValue(cached);
        try {
          final data = await NewsLoader.loadArticles();
          articles = articles.toValue(data);
        } on Object {
          // оставляем кэш на экране
        }
        return;
      }
    }

    if (forceRefresh && useSharedCache) {
      try {
        final data = await NewsLoader.loadArticles(forceRefresh: true);
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

  /// Pull-to-refresh.
  @action
  Future<void> refreshAll() => loadArticles(forceRefresh: true);

  Future<List<NewsArticleModel>> _fetchArticles() =>
      _fetchArticlesOverride?.call() ?? NewsLoader.loadArticles();
}
