import 'package:f1_pet_project/core/profile/controllers/notifications_preference_controller/notifications_preference_controller.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter/material.dart';
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

  group('NotificationsPreferenceController', () {
    test('load defaults to enabled', () async {
      final reminders = _FakeReminders();
      final analytics = RecordingAnalyticsGateway();
      final controller = NotificationsPreferenceController(
        reminders: reminders,
        analytics: analytics,
      );

      await controller.load();
      expect(controller.isLoaded, isTrue);
      expect(controller.userEnabled, isTrue);
      expect(controller.practiceRemindersEnabled, isTrue);
      expect(controller.effectivelyEnabled, isTrue);
      expect(controller.canToggle, isTrue);
      expect(controller.canTogglePractice, isTrue);
    });

    test('setEnabled false cancels reminders and logs analytics', () async {
      final reminders = _FakeReminders();
      final analytics = RecordingAnalyticsGateway();
      final controller = NotificationsPreferenceController(
        reminders: reminders,
        analytics: analytics,
      );
      await controller.load();

      await controller.setEnabled(enabled: false, locale: const Locale('en'));
      expect(controller.userEnabled, isFalse);
      expect(controller.effectivelyEnabled, isFalse);
      expect(reminders.cancelCalls, 1);
      expect(analytics.events.whereType<RaceReminderToggled>().single.enabled, isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(NotificationsPreferenceControllerBase.prefsKey), isFalse);
    });

    test('setEnabled true inits and syncs', () async {
      SharedPreferences.setMockInitialValues({
        NotificationsPreferenceControllerBase.prefsKey: false,
      });
      final reminders = _FakeReminders();
      final analytics = RecordingAnalyticsGateway();
      final controller = NotificationsPreferenceController(
        reminders: reminders,
        analytics: analytics,
      );
      await controller.load();
      expect(controller.userEnabled, isFalse);

      await controller.setEnabled(enabled: true, locale: const Locale('en'));
      expect(reminders.initCalls, 1);
      expect(reminders.permissionCalls, 1);
      expect(reminders.syncCalls, 1);
      expect(reminders.lastIncludePractices, isTrue);
    });

    test('practice toggle ignored when sessions disabled', () async {
      final reminders = _FakeReminders();
      final analytics = RecordingAnalyticsGateway();
      final controller = NotificationsPreferenceController(
        reminders: reminders,
        analytics: analytics,
      );
      await controller.load();
      await controller.setEnabled(enabled: false, locale: const Locale('en'));
      final syncBefore = reminders.syncCalls;

      await controller.setPracticeRemindersEnabled(enabled: false, locale: const Locale('en'));
      expect(controller.practiceRemindersEnabled, isTrue);
      expect(reminders.syncCalls, syncBefore);
      expect(analytics.events.whereType<PracticeReminderToggled>(), isEmpty);
    });

    test('practice toggle syncs when sessions enabled', () async {
      final reminders = _FakeReminders();
      final analytics = RecordingAnalyticsGateway();
      final controller = NotificationsPreferenceController(
        reminders: reminders,
        analytics: analytics,
      );
      await controller.load();

      await controller.setPracticeRemindersEnabled(enabled: false, locale: const Locale('en'));
      expect(controller.practiceRemindersEnabled, isFalse);
      expect(controller.practiceRemindersEffectivelyEnabled, isFalse);
      expect(reminders.lastIncludePractices, isFalse);
      expect(analytics.events.whereType<PracticeReminderToggled>().single.enabled, isFalse);
    });

    test('resync cancels when disabled', () async {
      final reminders = _FakeReminders();
      final controller = NotificationsPreferenceController(
        reminders: reminders,
        analytics: RecordingAnalyticsGateway(),
      );
      await controller.load();
      await controller.setEnabled(enabled: false, locale: const Locale('en'));
      final cancelBefore = reminders.cancelCalls;

      await controller.resync(locale: const Locale('en'));
      expect(reminders.cancelCalls, cancelBefore + 1);
    });
  });
}
