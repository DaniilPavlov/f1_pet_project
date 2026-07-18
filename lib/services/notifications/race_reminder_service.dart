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
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Локальные напоминания о гоночных сессиях за 30 минут до старта.
///
/// Расписание берёт из общего [ScheduleRepository] (кэш не чаще раза в сутки).
/// В ОС ставится только окно из [maxScheduledReminders] ближайших сессий;
/// при старте / resume / смене TZ или локали окно пересобирается.
class RaceReminderService {
  RaceReminderService({required ScheduleRepository scheduleRepository})
    : _scheduleRepository = scheduleRepository;

  static const reminderLead = Duration(minutes: 30);

  /// Сколько ближайших напоминаний держим в AlarmManager (rolling window).
  static const maxScheduledReminders = 10;

  static const _channelId = 'race_reminders';
  static const _channelName = 'Race reminders';

  /// Small icon: белый силуэт. Цветной mipmap Android в status bar не рисует.
  static const _androidIcon = '@drawable/ic_notification';

  static const _androidDetails = AndroidNotificationDetails(
    _channelId,
    _channelName,
    channelDescription: 'Reminders 30 minutes before F1 sessions',
    importance: Importance.high,
    priority: Priority.high,
    icon: _androidIcon,
    color: Color(0xFFE10600),
  );

  static const _notificationDetails = NotificationDetails(
    android: _androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  final ScheduleRepository _scheduleRepository;
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  /// Инициализирует плагин, таймзону и запрашивает разрешения.
  Future<void> init() async {
    tz_data.initializeTimeZones();
    await _configureLocalTimezone();

    const androidSettings = AndroidInitializationSettings(_androidIcon);
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    await _requestPermissions();
    await _ensureAndroidChannel();
  }

  /// Подтягивает расписание из общего кэша и планирует ближайшие уведомления.
  Future<void> sync({required Locale locale}) async {
    try {
      await _configureLocalTimezone();

      final loadResult = await _scheduleRepository.getSchedule();
      final l10n = await AppLocalizations.delegate.load(locale);
      final upcoming = _buildPlannedReminders(loadResult.schedule.raceTable.races, l10n);
      final toSchedule = upcoming.take(maxScheduledReminders).toList();

      // Всегда перепланируем: ОС могла сбросить алармы после перезагрузки / отзыва прав.
      await _plugin.cancelAll();
      await _scheduleAll(toSchedule);

      if (kDebugMode) {
        final next = toSchedule.isEmpty ? 'none' : toSchedule.first.notifyAt.toIso8601String();
        debugPrint(
          'RaceReminderService: scheduled ${toSchedule.length}/${upcoming.length} '
          'reminders, next=$next (network=${loadResult.fetchedFromNetwork})',
        );
      }
    } on Object catch (error, stackTrace) {
      debugPrint('RaceReminderService.sync failed: $error\n$stackTrace');
    }
  }

  Future<void> _configureLocalTimezone() async {
    try {
      final timeZoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } on Object catch (error) {
      debugPrint('RaceReminderService: timezone fallback to UTC ($error)');
      tz.setLocalLocation(tz.UTC);
    }
  }

  Future<void> _requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();

    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _ensureAndroidChannel() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: 'Reminders 30 minutes before F1 sessions',
        importance: Importance.high,
      ),
    );
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

    planned.sort((a, b) => a.notifyAt.compareTo(b.notifyAt));
    return planned;
  }

  Future<void> _scheduleAll(List<_PlannedReminder> planned) async {
    for (final item in planned) {
      final body = '${item.grandPrixName} · ${Utils.formatHourMinute(item.startLocal)}';
      final scheduledDate = tz.TZDateTime.from(item.notifyAt.toUtc(), tz.local);

      try {
        await _plugin.zonedSchedule(
          id: item.id,
          title: item.activityTitle,
          body: body,
          scheduledDate: scheduledDate,
          notificationDetails: _notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: item.grandPrixName,
        );
      } on Object catch (error) {
        debugPrint('RaceReminderService: exact failed for ${item.id}, try alarmClock: $error');
        try {
          await _plugin.zonedSchedule(
            id: item.id,
            title: item.activityTitle,
            body: body,
            scheduledDate: scheduledDate,
            notificationDetails: _notificationDetails,
            androidScheduleMode: AndroidScheduleMode.alarmClock,
            payload: item.grandPrixName,
          );
        } on Object catch (alarmClockError) {
          debugPrint(
            'RaceReminderService: alarmClock failed for ${item.id}, fallback inexact: $alarmClockError',
          );
          await _plugin.zonedSchedule(
            id: item.id,
            title: item.activityTitle,
            body: body,
            scheduledDate: scheduledDate,
            notificationDetails: _notificationDetails,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            payload: item.grandPrixName,
          );
        }
      }
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
}
