import 'package:f1_pet_project/core/results/hall_of_fame/managers/hall_of_fame_page_manager.dart';
import 'package:f1_pet_project/core/results/hall_of_fame/state/state_holders/hall_of_fame_page_state_holder.dart';
import 'package:f1_pet_project/core/results/hall_of_fame/state/state_models/hall_of_fame_page_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder экрана «Зал славы».
final hallOfFamePageStateHolderProvider =
    NotifierProvider.autoDispose<HallOfFamePageStateHolder, HallOfFamePageViewModel>(HallOfFamePageStateHolder.new);

/// Manager экрана «Зал славы».
final hallOfFamePageManagerProvider = Provider.autoDispose<HallOfFamePageManager>((ref) {
  final manager = HallOfFamePageManager(
    holder: ref.watch(hallOfFamePageStateHolderProvider.notifier),
    seasonsRepository: ref.watch(seasonsRepositoryProvider),
    standingsRepository: ref.watch(seasonStandingsRepositoryProvider),
    dataRefresh: ref.watch(appDataRefreshProvider),
  );
  ref.onDispose(manager.dispose);
  return manager;
});
