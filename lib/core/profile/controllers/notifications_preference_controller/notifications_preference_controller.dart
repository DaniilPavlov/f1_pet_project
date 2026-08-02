import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/firebase/remote_config_service.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notifications_preference_controller.g.dart';

/// Observer (MobX): пользовательские флаги локальных race reminders поверх Remote Config.
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

  /// Ключ SharedPreferences для user-toggle сессий.
  static const prefsKey = 'race_reminders_user_enabled';

  /// Ключ SharedPreferences: напоминания о free practice (FP1–FP3).
  static const practicePrefsKey = 'race_reminders_practice_enabled';

  final RaceReminderService _reminders;
  final RemoteConfigService _remoteConfig;
  final AnalyticsGateway _analytics;

  /// Локальный выбор пользователя (независимо от Remote Config).
  @observable
  bool userEnabled = true;

  /// Напоминания о практиках (имеет смысл только при [effectivelyEnabled]).
  @observable
  bool practiceRemindersEnabled = true;

  /// Prefs уже прочитаны.
  @observable
  bool isLoaded = false;

  /// Разрешает ли Remote Config локальные уведомления.
  @computed
  bool get remoteAllows => _remoteConfig.localNotificationsEnabled;

  /// Итоговый флаг: RC ∧ user.
  @computed
  bool get effectivelyEnabled => remoteAllows && userEnabled;

  /// Можно ли трогать главный switch в UI.
  @computed
  bool get canToggle => remoteAllows;

  /// Можно ли трогать switch практик (только когда сессионные reminders включены).
  @computed
  bool get canTogglePractice => effectivelyEnabled;

  /// Значение switch практик в UI: выключен, если выключены reminders в целом.
  @computed
  bool get practiceRemindersEffectivelyEnabled => effectivelyEnabled && practiceRemindersEnabled;

  /// Читает prefs при старте.
  @action
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    userEnabled = prefs.getBool(prefsKey) ?? true;
    practiceRemindersEnabled = prefs.getBool(practicePrefsKey) ?? true;
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
      await resync(locale: locale);
    } else {
      await _reminders.cancelAll();
    }
  }

  /// Вкл/выкл напоминаний о практиках (игнорируется, если сессии выключены).
  @action
  Future<void> setPracticeRemindersEnabled({required bool enabled, required Locale locale}) async {
    if (!effectivelyEnabled) {
      return;
    }
    practiceRemindersEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(practicePrefsKey, enabled);
    _analytics.log(PracticeReminderToggled(enabled: enabled));
    await resync(locale: locale);
  }

  /// Пересобирает расписание с учётом флага практик.
  Future<void> resync({required Locale locale}) async {
    if (!effectivelyEnabled) {
      await _reminders.cancelAll();
      return;
    }
    await _reminders.sync(locale: locale, includePractices: practiceRemindersEnabled);
  }
}
