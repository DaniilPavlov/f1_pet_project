import 'package:f1_pet_project/core/profile/managers/auth_page_manager.dart';
import 'package:f1_pet_project/core/profile/managers/notifications_preference_manager.dart';
import 'package:f1_pet_project/core/profile/state/state_holders/auth_page_state_holder.dart';
import 'package:f1_pet_project/core/profile/state/state_holders/notifications_preference_state_holder.dart';
import 'package:f1_pet_project/core/profile/state/state_models/auth_page_view_model.dart';
import 'package:f1_pet_project/core/profile/state/state_models/notifications_preference_view_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State holder экранов входа / регистрации.
final authPageStateHolderProvider =
    NotifierProvider.autoDispose<AuthPageStateHolder, AuthPageViewModel>(AuthPageStateHolder.new);

/// Manager экранов входа / регистрации.
final authPageManagerProvider = Provider.autoDispose<AuthPageManager>((ref) {
  return AuthPageManager(
    holder: ref.watch(authPageStateHolderProvider.notifier),
    authService: ref.watch(authServiceProvider),
  );
});

/// State holder настроек уведомлений.
final notificationsPreferenceStateHolderProvider =
    NotifierProvider<NotificationsPreferenceStateHolder, NotificationsPreferenceViewModel>(
      NotificationsPreferenceStateHolder.new,
    );

/// Manager настроек уведомлений.
final notificationsPreferenceManagerProvider = Provider<NotificationsPreferenceManager>((ref) {
  return NotificationsPreferenceManager(
    holder: ref.watch(notificationsPreferenceStateHolderProvider.notifier),
    reminders: ref.watch(raceReminderServiceProvider),
    analytics: ref.watch(analyticsGatewayProvider),
  );
});
