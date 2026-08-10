import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_page_view_model.freezed.dart';

/// Сколько карточек показывать за один «экран» пагинации.
const newsPageSize = 10;

/// UI-состояние ленты новостей ESPN.
@freezed
abstract class NewsPageViewModel with _$NewsPageViewModel {
  const NewsPageViewModel._();

  const factory NewsPageViewModel({
    /// Статьи новостей из ESPN.
    @Default(Loadable.loading()) Loadable<List<NewsArticleModel>> articles,
    /// Количество видимых статей (пагинация).
    @Default(newsPageSize) int visibleCount,
  }) = _NewsPageViewModel;

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
}
