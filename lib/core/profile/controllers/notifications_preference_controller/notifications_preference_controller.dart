import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Состояние prefs локальных race reminders.
@immutable
class NotificationsPreferenceState {
  const NotificationsPreferenceState({
    this.userEnabled = true,
    this.practiceRemindersEnabled = true,
    this.isLoaded = false,
  });

  final bool userEnabled;
  final bool practiceRemindersEnabled;
  final bool isLoaded;

  bool get effectivelyEnabled => userEnabled;

  bool get canToggle => true;

  bool get canTogglePractice => effectivelyEnabled;

  bool get practiceRemindersEffectivelyEnabled => effectivelyEnabled && practiceRemindersEnabled;

  NotificationsPreferenceState copyWith({
    bool? userEnabled,
    bool? practiceRemindersEnabled,
    bool? isLoaded,
  }) {
    return NotificationsPreferenceState(
      userEnabled: userEnabled ?? this.userEnabled,
      practiceRemindersEnabled: practiceRemindersEnabled ?? this.practiceRemindersEnabled,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

/// Хранит prefs + синхронизирует [RaceReminderService].
class NotificationsPreferenceController extends Notifier<NotificationsPreferenceState> {
  /// Ключ SharedPreferences для user-toggle сессий.
  static const prefsKey = 'race_reminders_user_enabled';

  /// Ключ SharedPreferences: напоминания о free practice (FP1–FP3).
  static const practicePrefsKey = 'race_reminders_practice_enabled';

  RaceReminderService get _reminders => ref.read(raceReminderServiceProvider);

  AnalyticsGateway get _analytics => ref.read(analyticsGatewayProvider);

  @override
  NotificationsPreferenceState build() => const NotificationsPreferenceState();

  /// Читает prefs при старте.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      userEnabled: prefs.getBool(prefsKey) ?? true,
      practiceRemindersEnabled: prefs.getBool(practicePrefsKey) ?? true,
      isLoaded: true,
    );
  }

  /// Вкл/выкл напоминаний; при включении запрашивает OS permissions.
  Future<void> setEnabled({required bool enabled, required Locale locale}) async {
    state = state.copyWith(userEnabled: enabled);
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
    if (!state.effectivelyEnabled) {
      return;
    }
    state = state.copyWith(practiceRemindersEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(practicePrefsKey, enabled);
    _analytics.log(PracticeReminderToggled(enabled: enabled));
    await resync(locale: locale);
  }

  /// Пересобирает расписание с учётом флага практик.
  Future<void> resync({required Locale locale}) async {
    if (!state.effectivelyEnabled) {
      await _reminders.cancelAll();
      return;
    }
    await _reminders.sync(locale: locale, includePractices: state.practiceRemindersEnabled);
  }
}

final notificationsPreferenceControllerProvider =
    NotifierProvider<NotificationsPreferenceController, NotificationsPreferenceState>(
      NotificationsPreferenceController.new,
    );
