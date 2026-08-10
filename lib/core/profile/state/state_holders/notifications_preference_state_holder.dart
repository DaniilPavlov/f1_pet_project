import 'package:f1_pet_project/core/profile/state/state_models/notifications_preference_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [NotificationsPreferenceViewModel] (app-level prefs напоминаний).
class NotificationsPreferenceStateHolder extends Notifier<NotificationsPreferenceViewModel> {
  @override
  NotificationsPreferenceViewModel build() => const NotificationsPreferenceViewModel();

  NotificationsPreferenceViewModel get viewModel => state;

  void setViewModel(NotificationsPreferenceViewModel value) => state = value;
}
