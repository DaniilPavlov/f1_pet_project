import 'package:f1_pet_project/core/news/state/state_models/news_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [NewsPageViewModel] для ленты новостей.
class NewsPageStateHolder extends Notifier<NewsPageViewModel> {
  @override
  NewsPageViewModel build() => const NewsPageViewModel();

  NewsPageViewModel get viewModel => state;

  void setViewModel(NewsPageViewModel value) => state = value;
}
