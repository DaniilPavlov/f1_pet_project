import 'package:f1_pet_project/core/schedule/managers/schedule_page_manager.dart';
import 'package:f1_pet_project/core/schedule/state/state_holders/schedule_page_state_holder.dart';
import 'package:f1_pet_project/core/schedule/state/state_models/schedule_page_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder экрана расписания.
final schedulePageStateHolderProvider =
    NotifierProvider.autoDispose<SchedulePageStateHolder, SchedulePageViewModel>(SchedulePageStateHolder.new);

/// Manager экрана расписания.
final schedulePageManagerProvider = Provider.autoDispose<SchedulePageManager>((ref) {
  final manager = SchedulePageManager(
    holder: ref.watch(schedulePageStateHolderProvider.notifier),
    scheduleRepository: ref.watch(scheduleRepositoryProvider),
    dataRefresh: ref.watch(appDataRefreshProvider),
  );
  ref.onDispose(manager.dispose);
  return manager;
});
