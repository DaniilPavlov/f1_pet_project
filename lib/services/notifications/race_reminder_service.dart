import 'dart:async';

import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/common/utils/platform_capabilities.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:f1_pet_project/services/deeplinks/f1pet_deep_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Локальные напоминания о гоночных сессиях за 30 минут до старта.
///
/// Расписание из [ScheduleRepository]. В ОС — окно из [_maxScheduledReminders]
/// ближайших сессий; при старте / resume / смене локали пересобирается.
///
/// Payload — `f1pet://race/<season>/<round>`; тапы отдаются в [notificationTaps]
/// и открывают Schedule (или Results, если уикенд уже live).
class RaceReminderService {
  RaceReminderService({
    required ScheduleRepository scheduleRepository,
  }) : _scheduleRepository = scheduleRepository;

  static const _reminderLead = Duration(minutes: 30);
  static const _maxScheduledReminders = 10;

  static const _channelId = 'race_reminders';
  static const _channelName = 'Race reminders';
  static const _androidIcon = 'ic_notification';

  static const _androidDetails = AndroidNotificationDetails(
    _channelId,
    _channelName,
    channelDescription: 'Reminders 30 minutes before F1 sessions',
    importance: Importance.high,
    priority: Priority.high,
    icon: _androidIcon,
    color: Color(0xFFE10600),
  );

  static const _notificationDetails = NotificationDetails(android: _androidDetails, iOS: DarwinNotificationDetails());

  final ScheduleRepository _scheduleRepository;
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  final _tapController = StreamController<Uri>.broadcast();

  var _initialized = false;

  /// Тапы по reminder (и cold-start launch). Слушает [F1PetDeepLinkHandler].
  Stream<Uri> get notificationTaps => _tapController.stream;

  bool get _notificationsAllowed => PlatformCapabilities.hasLocalNotifications;

  /// Инициализирует плагин и таймзону (без запроса permissions).
  Future<void> init() async {
    if (!_notificationsAllowed) {
      return;
    }
    tz_data.initializeTimeZones();
    await _configureLocalTimezone();

    if (_initialized) {
      return;
    }

    const androidSettings = AndroidInitializationSettings(_androidIcon);
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    await _ensureAndroidChannel();
    await _emitLaunchDetailsIfNeeded();
    _initialized = true;
  }

  /// Запрос разрешений уведомлений / exact alarms.
  Future<void> requestPermissions() async {
    if (!_notificationsAllowed) {
      return;
    }
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();

    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Снимает все запланированные reminders.
  Future<void> cancelAll() async {
    if (!PlatformCapabilities.hasLocalNotifications) {
      return;
    }
    await _plugin.cancelAll();
  }

  /// Подтягивает расписание и планирует ближайшие уведомления.
  ///
  /// [includePractices]: если false — FP1/FP2/FP3 не планируются (квали/спринт/гонка остаются).
  Future<void> sync({required Locale locale, bool includePractices = true}) async {
    if (!PlatformCapabilities.hasLocalNotifications) {
      return;
    }
    try {
      await _configureLocalTimezone();

      final loadResult = await _scheduleRepository.getSchedule();
      final l10n = await AppLocalizations.delegate.load(locale);
      final upcoming = buildPlannedReminders(
        loadResult.schedule.raceTable.races,
        l10n,
        includePractices: includePractices,
      );
      final toSchedule = upcoming.take(_maxScheduledReminders).toList();

      await _plugin.cancelAll();
      await _scheduleAll(toSchedule);

      final next = toSchedule.isEmpty ? 'none' : toSchedule.first.notifyAt.toIso8601String();
      logger.d(
        'RaceReminderService: scheduled ${toSchedule.length}/${upcoming.length} '
        'reminders, next=$next (network=${loadResult.fetchedFromNetwork})',
      );
    } on Object catch (error, stackTrace) {
      logger.e('RaceReminderService.sync failed', error: error, stackTrace: stackTrace);
    }
  }

  void _onNotificationResponse(NotificationResponse response) {
    _emitPayload(response.payload);
  }

  Future<void> _emitLaunchDetailsIfNeeded() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) {
      return;
    }
    _emitPayload(details?.notificationResponse?.payload);
  }

  void _emitPayload(String? payload) {
    final uri = parseTapPayload(payload);
    if (uri == null || _tapController.isClosed) {
      return;
    }
    _tapController.add(uri);
  }

  /// Парсит payload reminder в deep link. Публичный для unit-тестов.
  static Uri? parseTapPayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(payload);
    if (uri == null || uri.scheme != F1PetDeepLinks.scheme || uri.host != 'race') {
      return null;
    }
    return uri;
  }

  Future<void> _configureLocalTimezone() async {
    try {
      final timeZoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } on Object catch (error) {
      logger.w('RaceReminderService: timezone fallback to UTC', error: error);
      tz.setLocalLocation(tz.UTC);
    }
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

  /// Собирает будущие reminders (для unit-тестов и [sync]).
  @visibleForTesting
  static List<PlannedRaceReminder> buildPlannedReminders(
    List<RacesModel> races,
    AppLocalizations l10n, {
    required bool includePractices,
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now();
    final planned = <PlannedRaceReminder>[];

    for (final race in races) {
      final sessions = sessionEntries(race, l10n, includePractices: includePractices);

      for (final (typeKey, activityTitle, date) in sessions) {
        final localStart = RaceDateTimeHelper.toLocal(date);
        final notifyAt = localStart.subtract(_reminderLead);
        if (!notifyAt.isAfter(clock)) {
          continue;
        }

        planned.add(
          PlannedRaceReminder(
            id: notificationId(race.season, race.round, typeKey),
            activityTitle: activityTitle,
            grandPrixName: race.raceName,
            payload: F1PetDeepLinks.race(race.season, race.round).toString(),
            startLocal: localStart,
            notifyAt: notifyAt,
          ),
        );
      }
    }

    planned.sort((a, b) => a.notifyAt.compareTo(b.notifyAt));
    return planned;
  }

  /// Список сессий уикенда для планирования. Публичный для unit-тестов.
  static List<(String typeKey, String title, RaceDateModel date)> sessionEntries(
    RacesModel race,
    AppLocalizations l10n, {
    required bool includePractices,
  }) {
    return [
      if (includePractices && race.firstPractice != null) ('fp1', l10n.firstPractice, race.firstPractice!),
      if (includePractices && race.secondPractice != null) ('fp2', l10n.secondPractice, race.secondPractice!),
      if (includePractices && race.thirdPractice != null) ('fp3', l10n.thirdPractice, race.thirdPractice!),
      if (race.sprintQualifying != null) ('sq', l10n.sprintQualifying, race.sprintQualifying!),
      if (race.sprint != null) ('sprint', l10n.sprint, race.sprint!),
      if (race.qualifying != null) ('quali', l10n.qualifying, race.qualifying!),
      if (race.time != null && race.time!.isNotEmpty)
        ('race', l10n.race, RaceDateModel(date: race.date, time: race.time!)),
    ];
  }

  Future<void> _scheduleAll(List<PlannedRaceReminder> planned) async {
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
          payload: item.payload,
        );
      } on Object catch (error) {
        logger.w('RaceReminderService: exact failed for ${item.id}, try alarmClock', error: error);
        try {
          await _plugin.zonedSchedule(
            id: item.id,
            title: item.activityTitle,
            body: body,
            scheduledDate: scheduledDate,
            notificationDetails: _notificationDetails,
            androidScheduleMode: AndroidScheduleMode.alarmClock,
            payload: item.payload,
          );
        } on Object catch (alarmClockError) {
          logger.w('RaceReminderService: alarmClock failed for ${item.id}, fallback inexact', error: alarmClockError);
          await _plugin.zonedSchedule(
            id: item.id,
            title: item.activityTitle,
            body: body,
            scheduledDate: scheduledDate,
            notificationDetails: _notificationDetails,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            payload: item.payload,
          );
        }
      }
    }
  }

  /// Стабильный id уведомления. Публичный для unit-тестов.
  @visibleForTesting
  static int notificationId(String season, String round, String typeKey) {
    return Object.hash(season, round, typeKey) & 0x7fffffff;
  }
}

/// Планируемое локальное напоминание (публично для тестов planning-логики).
class PlannedRaceReminder {
  const PlannedRaceReminder({
    required this.id,
    required this.activityTitle,
    required this.grandPrixName,
    required this.payload,
    required this.startLocal,
    required this.notifyAt,
  });

  final int id;
  final String activityTitle;
  final String grandPrixName;
  final String payload;
  final DateTime startLocal;
  final DateTime notifyAt;
}
