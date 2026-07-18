import 'dart:convert';

import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Локальные напоминания о гоночных сессиях за 30 минут до старта.
///
/// Расписание берёт из общего [ScheduleRepository] (кэш не чаще раза в сутки).
/// При смене часового пояса или локали напоминания пересобираются.
class RaceReminderService {
  RaceReminderService({required ScheduleRepository scheduleRepository})
    : _scheduleRepository = scheduleRepository;

  static const reminderLead = Duration(minutes: 30);
  static const _channelId = 'race_reminders';
  static const _channelName = 'Race reminders';

  static const _tzOffsetKey = 'race_reminders_tz_offset_min';
  static const _localeKey = 'race_reminders_locale';
  static const _plannedKey = 'race_reminders_planned';

  final ScheduleRepository _scheduleRepository;
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  /// Инициализирует плагин, таймзону и запрашивает разрешения.
  Future<void> init() async {
    tz_data.initializeTimeZones();
    final timeZoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    await _requestPermissions();
  }

  /// Подтягивает расписание из общего кэша и планирует уведомления.
  Future<void> sync({required Locale locale}) async {
    try {
      final timeZoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));

      final prefs = await SharedPreferences.getInstance();
      final loadResult = await _scheduleRepository.getSchedule();

      final tzOffset = DateTime.now().timeZoneOffset.inMinutes;
      final localeCode = locale.languageCode;
      final tzChanged = prefs.getInt(_tzOffsetKey) != tzOffset;
      final localeChanged = prefs.getString(_localeKey) != localeCode;
      final hadPlanned = (prefs.getString(_plannedKey) ?? '').isNotEmpty;
      final shouldReschedule =
          loadResult.fetchedFromNetwork || tzChanged || localeChanged || !hadPlanned;

      final l10n = await AppLocalizations.delegate.load(locale);
      final planned = _buildPlannedReminders(loadResult.schedule.raceTable.races, l10n);

      await prefs.setString(_plannedKey, jsonEncode(planned.map((e) => e.toJson()).toList()));
      await prefs.setInt(_tzOffsetKey, tzOffset);
      await prefs.setString(_localeKey, localeCode);

      if (!shouldReschedule) {
        return;
      }

      await _plugin.cancelAll();
      await _scheduleAll(planned);

      if (kDebugMode) {
        debugPrint(
          'RaceReminderService: scheduled ${planned.length} reminders '
          '(network=${loadResult.fetchedFromNetwork}, tzChanged=$tzChanged, localeChanged=$localeChanged)',
        );
      }
    } on Object catch (error, stackTrace) {
      debugPrint('RaceReminderService.sync failed: $error\n$stackTrace');
    }
  }

  Future<void> _requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();

    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  List<_PlannedReminder> _buildPlannedReminders(List<RacesModel> races, AppLocalizations l10n) {
    final now = DateTime.now();
    final planned = <_PlannedReminder>[];

    for (final race in races) {
      final sessions = <(String typeKey, String title, RaceDateModel date)>[
        if (race.firstPractice != null) ('fp1', l10n.firstPractice, race.firstPractice!),
        if (race.secondPractice != null) ('fp2', l10n.secondPractice, race.secondPractice!),
        if (race.thirdPractice != null) ('fp3', l10n.thirdPractice, race.thirdPractice!),
        if (race.sprintQualifying != null) ('sq', l10n.sprintQualifying, race.sprintQualifying!),
        if (race.sprint != null) ('sprint', l10n.sprint, race.sprint!),
        if (race.qualifying != null) ('quali', l10n.qualifying, race.qualifying!),
        if (race.time != null && race.time!.isNotEmpty)
          ('race', l10n.race, RaceDateModel(date: race.date, time: race.time!)),
      ];

      for (final (typeKey, activityTitle, date) in sessions) {
        final localStart = RaceDateTimeHelper.toLocal(date);
        final notifyAt = localStart.subtract(reminderLead);
        if (!notifyAt.isAfter(now)) {
          continue;
        }

        planned.add(
          _PlannedReminder(
            id: _notificationId(race.season, race.round, typeKey),
            activityTitle: activityTitle,
            grandPrixName: race.raceName,
            startLocal: localStart,
            notifyAt: notifyAt,
          ),
        );
      }
    }

    return planned;
  }

  Future<void> _scheduleAll(List<_PlannedReminder> planned) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Reminders 30 minutes before F1 sessions',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    for (final item in planned) {
      final body = '${item.grandPrixName} · ${Utils.formatHourMinute(item.startLocal)}';

      await _plugin.zonedSchedule(
        id: item.id,
        title: item.activityTitle,
        body: body,
        scheduledDate: tz.TZDateTime.from(item.notifyAt, tz.local),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: item.grandPrixName,
      );
    }
  }

  static int _notificationId(String season, String round, String typeKey) {
    return Object.hash(season, round, typeKey) & 0x7fffffff;
  }
}

class _PlannedReminder {
  const _PlannedReminder({
    required this.id,
    required this.activityTitle,
    required this.grandPrixName,
    required this.startLocal,
    required this.notifyAt,
  });

  final int id;
  final String activityTitle;
  final String grandPrixName;
  final DateTime startLocal;
  final DateTime notifyAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'activityTitle': activityTitle,
    'grandPrixName': grandPrixName,
    'startLocal': startLocal.toIso8601String(),
    'notifyAt': notifyAt.toIso8601String(),
  };
}
