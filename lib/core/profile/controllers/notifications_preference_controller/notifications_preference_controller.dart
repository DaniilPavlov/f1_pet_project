import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/firebase/remote_config_service.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notifications_preference_controller.g.dart';

/// Observer (MobX): пользовательский флаг локальных race reminders поверх Remote Config.
class NotificationsPreferenceController = NotificationsPreferenceControllerBase
    with _$NotificationsPreferenceController;

/// Хранит prefs + синхронизирует [RaceReminderService].
abstract class NotificationsPreferenceControllerBase with Store {
  NotificationsPreferenceControllerBase({
    required RaceReminderService reminders,
    required RemoteConfigService remoteConfig,
    required AnalyticsGateway analytics,
  }) : _reminders = reminders,
       _remoteConfig = remoteConfig,
       _analytics = analytics;

  /// Ключ SharedPreferences для user-toggle.
  static const prefsKey = 'race_reminders_user_enabled';

  final RaceReminderService _reminders;
  final RemoteConfigService _remoteConfig;
  final AnalyticsGateway _analytics;

  /// Локальный выбор пользователя (независимо от Remote Config).
  @observable
  bool userEnabled = true;

  /// Prefs уже прочитаны.
  @observable
  bool isLoaded = false;

  /// Разрешает ли Remote Config локальные уведомления.
  @computed
  bool get remoteAllows => _remoteConfig.localNotificationsEnabled;

  /// Итоговый флаг: RC ∧ user.
  @computed
  bool get effectivelyEnabled => remoteAllows && userEnabled;

  /// Можно ли трогать switch в UI.
  @computed
  bool get canToggle => remoteAllows;

  /// Читает prefs при старте.
  @action
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    userEnabled = prefs.getBool(prefsKey) ?? true;
    isLoaded = true;
  }

  /// Вкл/выкл напоминаний; при включении запрашивает OS permissions.
  @action
  Future<void> setEnabled({required bool enabled, required Locale locale}) async {
    if (!remoteAllows && enabled) {
      return;
    }
    userEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefsKey, enabled);
    _analytics.log(RaceReminderToggled(enabled: enabled));

    if (enabled) {
      await _reminders.init();
      await _reminders.requestPermissions();
      await _reminders.sync(locale: locale);
    } else {
      await _reminders.cancelAll();
    }
  }
}
