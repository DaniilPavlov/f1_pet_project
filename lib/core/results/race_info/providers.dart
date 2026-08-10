import 'package:f1_pet_project/core/results/race_info/managers/race_info_page_manager.dart';
import 'package:f1_pet_project/core/results/race_info/state/state_holders/race_info_page_state_holder.dart';
import 'package:f1_pet_project/core/results/race_info/state/state_models/race_info_page_view_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder экрана детали гонки (family по [RacesModel]).
final raceInfoPageStateHolderProvider =
    NotifierProvider.autoDispose.family<RaceInfoPageStateHolder, RaceInfoPageViewModel, RacesModel>(
      RaceInfoPageStateHolder.new,
    );

/// Manager экрана детали гонки.
final raceInfoPageManagerProvider = Provider.autoDispose.family<RaceInfoPageManager, RacesModel>((ref, raceModel) {
  final manager = RaceInfoPageManager(
    raceModel: raceModel,
    holder: ref.watch(raceInfoPageStateHolderProvider(raceModel).notifier),
    scheduleRepository: ref.watch(scheduleRepositoryProvider),
    raceWeekendRepository: ref.watch(raceWeekendRepositoryProvider),
    dataRefresh: ref.watch(appDataRefreshProvider),
  );
  ref.onDispose(manager.dispose);
  return manager;
});
