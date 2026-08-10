import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'constructor_page_view_model.freezed.dart';

/// UI-состояние экрана конструктора.
@freezed
abstract class ConstructorPageViewModel with _$ConstructorPageViewModel {
  const ConstructorPageViewModel._();

  const factory ConstructorPageViewModel({
    /// Карьерная статистика (тоталы и список гонок).
    @Default(Loadable.loading()) Loadable<CareerStats<DriverModel>> careerStats,
    /// Новости из ESPN.
    @Default(Loadable.loading()) Loadable<List<NewsArticleModel>> espnNews,
  }) = _ConstructorPageViewModel;

  CustomException? get screenError => firstException([careerStats]);

  bool get isLoaded => careerStats.isValue && careerStats.value != null;

  List<NewsArticleModel> get news => espnNews.value ?? const [];
}
