import 'package:f1_pet_project/core/results/managers/results_page_manager.dart';
import 'package:f1_pet_project/core/results/state/state_holders/results_page_state_holder.dart';
import 'package:f1_pet_project/core/results/state/state_models/results_page_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder экрана результатов.
final resultsPageStateHolderProvider =
    NotifierProvider.autoDispose<ResultsPageStateHolder, ResultsPageViewModel>(ResultsPageStateHolder.new);

/// Manager экрана результатов.
final resultsPageManagerProvider = Provider.autoDispose<ResultsPageManager>((ref) {
  final manager = ResultsPageManager(
    holder: ref.watch(resultsPageStateHolderProvider.notifier),
    resultsRepository: ref.watch(resultsRepositoryProvider),
    dataRefresh: ref.watch(appDataRefreshProvider),
    liveWeekend: ref.watch(liveWeekendControllerProvider.notifier),
    scoreboardIsValue: () => ref.read(liveWeekendControllerProvider).scoreboard.isValue,
  );
  ref.onDispose(manager.dispose);
  return manager;
});
