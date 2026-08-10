import 'package:f1_pet_project/core/schedule/state/state_models/schedule_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [SchedulePageViewModel] для экрана расписания.
class SchedulePageStateHolder extends Notifier<SchedulePageViewModel> {
  @override
  SchedulePageViewModel build() {
    final now = DateTime.now();
    return SchedulePageViewModel(
      now: now,
      selectedDate: now,
      focusedDate: now,
    );
  }

  SchedulePageViewModel get viewModel => state;

  void setViewModel(SchedulePageViewModel value) => state = value;
}
