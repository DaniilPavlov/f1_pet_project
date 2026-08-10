import 'package:f1_pet_project/core/results/race_search/managers/race_search_page_manager.dart';
import 'package:f1_pet_project/core/results/race_search/state/state_holders/race_search_page_state_holder.dart';
import 'package:f1_pet_project/core/results/race_search/state/state_models/race_search_page_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder экрана поиска гонки (family по languageCode).
final raceSearchPageStateHolderProvider =
    NotifierProvider.autoDispose.family<RaceSearchPageStateHolder, RaceSearchPageViewModel, String>(
      RaceSearchPageStateHolder.new,
    );

/// Manager экрана поиска гонки.
final raceSearchPageManagerProvider = Provider.autoDispose.family<RaceSearchPageManager, String>((ref, languageCode) {
  final manager = RaceSearchPageManager(
    languageCode: languageCode,
    holder: ref.watch(raceSearchPageStateHolderProvider(languageCode).notifier),
    raceWeekendRepository: ref.watch(raceWeekendRepositoryProvider),
    analytics: ref.watch(analyticsGatewayProvider),
  );
  ref.onDispose(manager.dispose);
  return manager;
});
