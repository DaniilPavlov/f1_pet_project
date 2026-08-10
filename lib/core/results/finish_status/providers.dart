import 'package:f1_pet_project/core/results/finish_status/managers/finish_status_page_manager.dart';
import 'package:f1_pet_project/core/results/finish_status/state/state_holders/finish_status_page_state_holder.dart';
import 'package:f1_pet_project/core/results/finish_status/state/state_models/finish_status_page_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder экрана статусов финиша.
final finishStatusPageStateHolderProvider =
    NotifierProvider.autoDispose<FinishStatusPageStateHolder, FinishStatusPageViewModel>(
      FinishStatusPageStateHolder.new,
    );

/// Manager экрана статусов финиша.
final finishStatusPageManagerProvider = Provider.autoDispose<FinishStatusPageManager>((ref) {
  final manager = FinishStatusPageManager(
    holder: ref.watch(finishStatusPageStateHolderProvider.notifier),
    finishStatusRepository: ref.watch(finishStatusRepositoryProvider),
    seasonsRepository: ref.watch(seasonsRepositoryProvider),
    dataRefresh: ref.watch(appDataRefreshProvider),
  );
  ref.onDispose(manager.dispose);
  return manager;
});
