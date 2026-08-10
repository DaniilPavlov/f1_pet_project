import 'package:f1_pet_project/core/profile/managers/notifications_preference_manager.dart';
import 'package:f1_pet_project/core/profile/providers.dart';
import 'package:f1_pet_project/core/profile/state/state_models/notifications_preference_view_model.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/recording_analytics_gateway.dart';

class _FakeReminders extends RaceReminderService {
  _FakeReminders() : super(scheduleRepository: FakeScheduleRepository());

  int initCalls = 0;
  int permissionCalls = 0;
  int cancelCalls = 0;
  int syncCalls = 0;
  bool? lastIncludePractices;

  @override
  Future<void> init() async {
    initCalls++;
  }

  @override
  Future<void> requestPermissions() async {
    permissionCalls++;
  }

  @override
  Future<void> cancelAll() async {
    cancelCalls++;
  }

  @override
  Future<void> sync({required Locale locale, bool includePractices = true}) async {
    syncCalls++;
    lastIncludePractices = includePractices;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('NotificationsPreferenceManager', () {
    ({ProviderContainer container, _FakeReminders reminders, RecordingAnalyticsGateway analytics}) setup() {
      final reminders = _FakeReminders();
      final analytics = RecordingAnalyticsGateway();
      final container = ProviderContainer(
        overrides: [
          raceReminderServiceProvider.overrideWithValue(reminders),
          analyticsGatewayProvider.overrideWithValue(analytics),
        ],
      );
      addTearDown(container.dispose);
      return (container: container, reminders: reminders, analytics: analytics);
    }

    NotificationsPreferenceViewModel stateOf(ProviderContainer container) =>
        container.read(notificationsPreferenceStateHolderProvider);

    NotificationsPreferenceManager managerOf(ProviderContainer container) =>
        container.read(notificationsPreferenceManagerProvider);

    test('load defaults to enabled', () async {
      final env = setup();
      await managerOf(env.container).load();
      final state = stateOf(env.container);
      expect(state.isLoaded, isTrue);
      expect(state.userEnabled, isTrue);
      expect(state.practiceRemindersEnabled, isTrue);
      expect(state.effectivelyEnabled, isTrue);
      expect(state.canToggle, isTrue);
      expect(state.canTogglePractice, isTrue);
    });

    test('setEnabled false cancels reminders and logs analytics', () async {
      final env = setup();
      await managerOf(env.container).load();

      await managerOf(env.container).setEnabled(enabled: false, locale: const Locale('en'));
      final state = stateOf(env.container);
      expect(state.userEnabled, isFalse);
      expect(state.effectivelyEnabled, isFalse);
      expect(env.reminders.cancelCalls, 1);
      expect(env.analytics.events.whereType<RaceReminderToggled>().single.enabled, isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(NotificationsPreferenceManager.prefsKey), isFalse);
    });

    test('setEnabled true inits and syncs', () async {
      SharedPreferences.setMockInitialValues({
        NotificationsPreferenceManager.prefsKey: false,
      });
      final env = setup();
      await managerOf(env.container).load();
      expect(stateOf(env.container).userEnabled, isFalse);

      await managerOf(env.container).setEnabled(enabled: true, locale: const Locale('en'));
      expect(env.reminders.initCalls, 1);
      expect(env.reminders.permissionCalls, 1);
      expect(env.reminders.syncCalls, 1);
      expect(env.reminders.lastIncludePractices, isTrue);
    });

    test('practice toggle ignored when sessions disabled', () async {
      final env = setup();
      await managerOf(env.container).load();
      await managerOf(env.container).setEnabled(enabled: false, locale: const Locale('en'));
      final syncBefore = env.reminders.syncCalls;

      await managerOf(env.container).setPracticeRemindersEnabled(enabled: false, locale: const Locale('en'));
      expect(stateOf(env.container).practiceRemindersEnabled, isTrue);
      expect(env.reminders.syncCalls, syncBefore);
      expect(env.analytics.events.whereType<PracticeReminderToggled>(), isEmpty);
    });

    test('practice toggle syncs when sessions enabled', () async {
      final env = setup();
      await managerOf(env.container).load();

      await managerOf(env.container).setPracticeRemindersEnabled(enabled: false, locale: const Locale('en'));
      final state = stateOf(env.container);
      expect(state.practiceRemindersEnabled, isFalse);
      expect(state.practiceRemindersEffectivelyEnabled, isFalse);
      expect(env.reminders.lastIncludePractices, isFalse);
      expect(env.analytics.events.whereType<PracticeReminderToggled>().single.enabled, isFalse);
    });

    test('resync cancels when disabled', () async {
      final env = setup();
      await managerOf(env.container).load();
      await managerOf(env.container).setEnabled(enabled: false, locale: const Locale('en'));
      final cancelBefore = env.reminders.cancelCalls;

      await managerOf(env.container).resync(locale: const Locale('en'));
      expect(env.reminders.cancelCalls, cancelBefore + 1);
    });
  });
}
