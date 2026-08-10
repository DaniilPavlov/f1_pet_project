import 'package:f1_pet_project/core/results/season_rewind/managers/season_rewind_page_manager.dart';
import 'package:f1_pet_project/core/results/season_rewind/state/state_holders/season_rewind_page_state_holder.dart';
import 'package:f1_pet_project/core/results/season_rewind/state/state_models/season_rewind_page_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder экрана перемотки сезона.
final seasonRewindPageStateHolderProvider =
    NotifierProvider.autoDispose<SeasonRewindPageStateHolder, SeasonRewindPageViewModel>(
      SeasonRewindPageStateHolder.new,
    );

/// Manager экрана перемотки сезона.
final seasonRewindPageManagerProvider = Provider.autoDispose<SeasonRewindPageManager>((ref) {
  final manager = SeasonRewindPageManager(
    holder: ref.watch(seasonRewindPageStateHolderProvider.notifier),
    seasonsRepository: ref.watch(seasonsRepositoryProvider),
    standingsRepository: ref.watch(seasonStandingsRepositoryProvider),
    raceWeekendRepository: ref.watch(raceWeekendRepositoryProvider),
    dataRefresh: ref.watch(appDataRefreshProvider),
  );
  ref.onDispose(manager.dispose);
  return manager;
});
