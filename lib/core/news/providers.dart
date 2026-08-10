import 'package:f1_pet_project/core/news/managers/news_page_manager.dart';
import 'package:f1_pet_project/core/news/state/state_holders/news_page_state_holder.dart';
import 'package:f1_pet_project/core/news/state/state_models/news_page_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder ленты новостей.
final newsPageStateHolderProvider =
    NotifierProvider.autoDispose<NewsPageStateHolder, NewsPageViewModel>(NewsPageStateHolder.new);

/// Manager ленты новостей.
final newsPageManagerProvider = Provider.autoDispose<NewsPageManager>((ref) {
  return NewsPageManager(
    holder: ref.watch(newsPageStateHolderProvider.notifier),
    newsRepository: ref.watch(newsRepositoryProvider),
    dataRefresh: ref.watch(appDataRefreshProvider),
  );
});
