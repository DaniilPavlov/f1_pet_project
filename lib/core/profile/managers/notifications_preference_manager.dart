import 'package:f1_pet_project/core/profile/state/state_holders/notifications_preference_state_holder.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Хранит prefs + синхронизирует [RaceReminderService].
class NotificationsPreferenceManager {
  NotificationsPreferenceManager({
    required NotificationsPreferenceStateHolder holder,
    required RaceReminderService reminders,
    required AnalyticsGateway analytics,
  }) : _holder = holder,
       _reminders = reminders,
       _analytics = analytics;

  /// Ключ SharedPreferences для user-toggle сессий.
  static const prefsKey = 'race_reminders_user_enabled';

  /// Ключ SharedPreferences: напоминания о free practice (FP1–FP3).
  static const practicePrefsKey = 'race_reminders_practice_enabled';

  final NotificationsPreferenceStateHolder _holder;
  final RaceReminderService _reminders;
  final AnalyticsGateway _analytics;

  /// Читает prefs при старте.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _holder.setViewModel(
      _holder.viewModel.copyWith(
        userEnabled: prefs.getBool(prefsKey) ?? true,
        practiceRemindersEnabled: prefs.getBool(practicePrefsKey) ?? true,
        isLoaded: true,
      ),
    );
  }

  /// Вкл/выкл напоминаний; при включении запрашивает OS permissions.
  Future<void> setEnabled({required bool enabled, required Locale locale}) async {
    _holder.setViewModel(_holder.viewModel.copyWith(userEnabled: enabled));
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
  Future<void> setPracticeRemindersEnabled({required bool enabled, required Locale locale}) async {
    if (!_holder.viewModel.effectivelyEnabled) {
      return;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(practiceRemindersEnabled: enabled));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(practicePrefsKey, enabled);
    _analytics.log(PracticeReminderToggled(enabled: enabled));
    await resync(locale: locale);
  }

  /// Пересобирает расписание с учётом флага практик.
  Future<void> resync({required Locale locale}) async {
    if (!_holder.viewModel.effectivelyEnabled) {
      await _reminders.cancelAll();
      return;
    }
    await _reminders.sync(
      locale: locale,
      includePractices: _holder.viewModel.practiceRemindersEnabled,
    );
  }
}
