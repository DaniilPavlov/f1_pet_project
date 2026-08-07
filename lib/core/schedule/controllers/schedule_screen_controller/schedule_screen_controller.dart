import 'dart:async';

import 'package:f1_pet_project/common/utils/constants/assets.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/offline_cached_banner.dart';
import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/scroll_controller_extension.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

/// Тип сессии выбранного дня (локализация — в UI).
enum ScheduleSessionKind {
  firstPractice,
  secondPractice,
  thirdPractice,
  sprintQualifying,
  sprint,
  qualifying,
  race,
}

/// Одна сессия в расписании выбранного дня.
@immutable
class ScheduleDaySession {
  const ScheduleDaySession({required this.kind, required this.date});

  final ScheduleSessionKind kind;
  final RaceDateModel date;
}

/// Данные расписания выбранного дня (без Widget).
@immutable
class ScheduleSelectedDay {
  const ScheduleSelectedDay({this.raceName, this.sessions = const []});

  final String? raceName;
  final List<ScheduleDaySession> sessions;

  bool get hasSessions => sessions.isNotEmpty;

  static const empty = ScheduleSelectedDay();
}

/// Состояние экрана расписания.
@immutable
class ScheduleScreenState {
  ScheduleScreenState({
    this.racesElements = const Loadable.loading(),
    this.allDataIsLoaded = false,
    DateTime? now,
    DateTime? selectedDate,
    DateTime? focusedDate,
    this.selectedDay = ScheduleSelectedDay.empty,
    this.showingCachedData = false,
  }) : now = now ?? DateTime.now(),
       selectedDate = selectedDate ?? DateTime.now(),
       focusedDate = focusedDate ?? DateTime.now();

  final Loadable<List<RacesModel>> racesElements;
  final bool allDataIsLoaded;
  final DateTime now;
  final DateTime selectedDate;
  final DateTime focusedDate;
  final ScheduleSelectedDay selectedDay;

  /// Офлайн-fallback: расписание из кэша после сбоя сети.
  final bool showingCachedData;

  CustomException? get screenError => racesElements.exception;

  bool get selectedDayHasSessions => selectedDay.hasSessions;

  /// Ближайшая ещё не стартовавшая гонка.
  RacesModel? get upcomingRace {
    final races = racesElements.value;
    if (races == null) {
      return null;
    }
    final upcoming = races.where((race) => RaceDateTimeHelper.isUpcoming(race, now)).toList()
      ..sort((a, b) => RaceDateTimeHelper.raceLocal(a).compareTo(RaceDateTimeHelper.raceLocal(b)));
    return upcoming.isEmpty ? null : upcoming.first;
  }

  CountdownParts get upcomingCountdown {
    final race = upcomingRace;
    if (race == null) {
      return CountdownParts.zero;
    }
    return CountdownParts.until(RaceDateTimeHelper.countdownTarget(race), now);
  }

  ScheduleScreenState copyWith({
    Loadable<List<RacesModel>>? racesElements,
    bool? allDataIsLoaded,
    DateTime? now,
    DateTime? selectedDate,
    DateTime? focusedDate,
    ScheduleSelectedDay? selectedDay,
    bool? showingCachedData,
  }) {
    return ScheduleScreenState(
      racesElements: racesElements ?? this.racesElements,
      allDataIsLoaded: allDataIsLoaded ?? this.allDataIsLoaded,
      now: now ?? this.now,
      selectedDate: selectedDate ?? this.selectedDate,
      focusedDate: focusedDate ?? this.focusedDate,
      selectedDay: selectedDay ?? this.selectedDay,
      showingCachedData: showingCachedData ?? this.showingCachedData,
    );
  }
}

/// Календарь сессий; если день пустой — ближайший ГП с countdown.
class ScheduleScreenController extends Notifier<ScheduleScreenState> {
  ScheduleScreenController({
    @visibleForTesting Future<ScheduleModel> Function()? fetchScheduleForTest,
  }) : _fetchScheduleForTest = fetchScheduleForTest;

  final Future<ScheduleModel> Function()? _fetchScheduleForTest;

  final scrollController = ScrollController();
  Timer? _ticker;
  var _lastOfflineFallback = false;

  ScheduleRepository? get _scheduleRepository {
    if (_fetchScheduleForTest != null) {
      return null;
    }
    return ref.read(scheduleRepositoryProvider);
  }

  AppDataRefresh? get _dataRefresh {
    if (_fetchScheduleForTest != null) {
      return null;
    }
    return ref.read(appDataRefreshProvider);
  }

  @override
  ScheduleScreenState build() {
    ref.onDispose(() {
      _ticker?.cancel();
      _ticker = null;
      scrollController.dispose();
    });
    final now = DateTime.now();
    return ScheduleScreenState(now: now, selectedDate: now, focusedDate: now);
  }

  /// Загружает расписание сезона и выбирает текущий день.
  Future<void> loadAllData() async {
    state = state.copyWith(allDataIsLoaded: false);
    await _loadSchedule();
    if (!ref.mounted) {
      return;
    }

    if (state.screenError == null) {
      onSelectDay(DateTime.now(), DateTime.now());
      _startTicker();
    }

    state = state.copyWith(allDataIsLoaded: state.screenError == null);
  }

  /// Pull-to-refresh: единый сброс кэшей и перезагрузка календаря.
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    if (!ref.mounted) {
      return;
    }
    await loadAllData();
  }

  /// Обрабатывает выбор даты в календаре и обновляет список сессий.
  void onSelectDay(DateTime newSelectedDate, DateTime focusedDay) {
    state = state.copyWith(selectedDate: newSelectedDate, focusedDate: focusedDay);
    _showScheduleOfSelectedDate();
  }

  /// Сохраняет видимый месяц при свайпе/стрелках календаря.
  void onPageChanged(DateTime focusedDay) {
    state = state.copyWith(focusedDate: focusedDay);
  }

  /// Возвращает иконку для дня с гонкой или сессией, иначе null.
  String? getLogoPath(DateTime day) {
    final races = state.racesElements.value;
    if (races == null) {
      return null;
    }

    if (races.any((race) => isSameDay(DateTime.parse(race.date), day))) {
      return Assets.calendar.finish;
    }
    if (races.any((race) => _hasSessionOnDay(race, day))) {
      return Assets.calendar.car;
    }
    return null;
  }

  bool _hasSessionOnDay(RacesModel race, DateTime day) {
    return _raceSessions(race).any((session) => session != null && isSameDay(DateTime.parse(session.date), day));
  }

  List<RaceDateModel?> _raceSessions(RacesModel race) => [
    race.firstPractice,
    race.secondPractice,
    race.thirdPractice,
    race.sprintQualifying,
    race.sprint,
    race.qualifying,
  ];

  void _addSessionsForDay(RacesModel race, DateTime day, List<ScheduleDaySession> schedule) {
    final sessions = <(RaceDateModel?, ScheduleSessionKind)>[
      (race.firstPractice, ScheduleSessionKind.firstPractice),
      (race.secondPractice, ScheduleSessionKind.secondPractice),
      (race.thirdPractice, ScheduleSessionKind.thirdPractice),
      (race.sprintQualifying, ScheduleSessionKind.sprintQualifying),
      (race.sprint, ScheduleSessionKind.sprint),
      (race.qualifying, ScheduleSessionKind.qualifying),
    ];

    for (final (session, kind) in sessions) {
      if (session != null && isSameDay(DateTime.parse(session.date), day)) {
        schedule.add(ScheduleDaySession(kind: kind, date: session));
      }
    }
  }

  void _showScheduleOfSelectedDate() {
    final races = state.racesElements.value;
    if (races == null) {
      state = state.copyWith(selectedDay: ScheduleSelectedDay.empty);
      return;
    }

    final selectedDate = state.selectedDate;
    for (var i = 0; i < races.length; i++) {
      final race = races[i];
      if (isSameDay(DateTime.parse(race.date), selectedDate) || DateTime.parse(race.date).isAfter(selectedDate)) {
        final newSessions = <ScheduleDaySession>[];
        _addSessionsForDay(race, selectedDate, newSessions);
        if (isSameDay(DateTime.parse(race.date), selectedDate)) {
          newSessions.add(
            ScheduleDaySession(
              kind: ScheduleSessionKind.race,
              date: RaceDateModel(date: race.date, time: race.time ?? ''),
            ),
          );
        }

        final selectedDay = newSessions.isEmpty
            ? ScheduleSelectedDay.empty
            : ScheduleSelectedDay(raceName: race.raceName, sessions: newSessions);

        state = state.copyWith(selectedDay: selectedDay);
        if (selectedDay.hasSessions) {
          Future<void>.delayed(const Duration(milliseconds: 100), scrollController.animateToBottom);
        }
        return;
      }
    }

    state = state.copyWith(selectedDay: ScheduleSelectedDay.empty);
  }

  void _startTicker() {
    _ticker?.cancel();
    _tickNow();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tickNow());
  }

  void _tickNow() {
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(now: DateTime.now());
  }

  Future<void> _loadSchedule() async {
    await runAsyncLoad<ScheduleModel, List<RacesModel>>(
      fetch: _fetchSchedule,
      getField: () => state.racesElements,
      setField: (value) => state = state.copyWith(racesElements: value),
      onSuccess: (data) {
        state = state.copyWith(
          racesElements: state.racesElements.toValue(data!.raceTable.races),
          showingCachedData: _lastOfflineFallback,
        );
      },
    );
  }

  /// После появления сети — спрятать баннер без перезагрузки.
  Future<void> dismissOfflineBannerIfOnline() async {
    final next = await clearOfflineBannerIfOnline(currentlyShowing: state.showingCachedData);
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(showingCachedData: next);
  }

  Future<ScheduleModel> _fetchSchedule() async {
    final forTest = _fetchScheduleForTest;
    if (forTest != null) {
      _lastOfflineFallback = false;
      return forTest();
    }
    final result = await _scheduleRepository!.getSchedule();
    _lastOfflineFallback = result.offlineFallback;
    return result.schedule;
  }
}

final scheduleScreenControllerProvider =
    NotifierProvider.autoDispose<ScheduleScreenController, ScheduleScreenState>(ScheduleScreenController.new);
