import 'dart:async';

import 'package:f1_pet_project/common/utils/constants/assets.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/offline_cached_banner.dart';
import 'package:f1_pet_project/common/utils/helpers/scroll_controller_extension.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/core/schedule/state/state_holders/schedule_page_state_holder.dart';
import 'package:f1_pet_project/core/schedule/state/state_models/schedule_page_view_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// Календарь сессий; если день пустой — ближайший ГП с countdown.
class SchedulePageManager {
  SchedulePageManager({
    required SchedulePageStateHolder holder,
    ScheduleRepository? scheduleRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<ScheduleModel> Function()? fetchScheduleForTest,
  }) : _holder = holder,
       _scheduleRepository = scheduleRepository,
       _dataRefresh = dataRefresh,
       _fetchScheduleForTest = fetchScheduleForTest;

  final SchedulePageStateHolder _holder;
  final ScheduleRepository? _scheduleRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<ScheduleModel> Function()? _fetchScheduleForTest;

  /// Управляет прокруткой списка сессий к низу при выборе дня.
  final scrollController = ScrollController();
  Timer? _ticker;
  var _disposed = false;
  var _lastOfflineFallback = false;

  /// Загружает расписание сезона и инициализирует компоненты.
  Future<void> loadAllData() async {
    _holder.setViewModel(_holder.viewModel.copyWith(allDataIsLoaded: false));
    await _loadSchedule();
    if (_disposed) {
      return;
    }

    if (_holder.viewModel.screenError == null) {
      onSelectDay(DateTime.now(), DateTime.now());
      _startTicker();
    }

    _holder.setViewModel(
      _holder.viewModel.copyWith(allDataIsLoaded: _holder.viewModel.screenError == null),
    );
  }

  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    if (_disposed) {
      return;
    }
    await loadAllData();
  }

  /// Обрабатывает выбор даты в календаре и обновляет список сессий.
  void onSelectDay(DateTime newSelectedDate, DateTime focusedDay) {
    _holder.setViewModel(
      _holder.viewModel.copyWith(selectedDate: newSelectedDate, focusedDate: focusedDay),
    );
    _showScheduleOfSelectedDate();
  }

  /// Сохраняет видимый месяц при свайпе/стрелках календаря.
  void onPageChanged(DateTime focusedDay) {
    _holder.setViewModel(_holder.viewModel.copyWith(focusedDate: focusedDay));
  }

  /// Возвращает иконку для дня с гонкой или сессией, иначе null.
  String? getLogoPath(DateTime day) {
    final races = _holder.viewModel.racesElements.value;
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

  /// После появления сети — спрятать баннер без перезагрузки.
  Future<void> dismissOfflineBannerIfOnline() async {
    final next = await clearOfflineBannerIfOnline(
      currentlyShowing: _holder.viewModel.showingCachedData,
    );
    if (_disposed) {
      return;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(showingCachedData: next));
  }

  /// Очищает ресурсы менеджера и останавливает тикер.
  void dispose() {
    _disposed = true;
    _ticker?.cancel();
    _ticker = null;
    scrollController.dispose();
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
    final races = _holder.viewModel.racesElements.value;
    if (races == null) {
      _holder.setViewModel(_holder.viewModel.copyWith(selectedDay: ScheduleSelectedDay.empty));
      return;
    }

    final selectedDate = _holder.viewModel.selectedDate;
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

        _holder.setViewModel(_holder.viewModel.copyWith(selectedDay: selectedDay));
        if (selectedDay.hasSessions) {
          Future<void>.delayed(const Duration(milliseconds: 100), scrollController.animateToBottom);
        }
        return;
      }
    }

    _holder.setViewModel(_holder.viewModel.copyWith(selectedDay: ScheduleSelectedDay.empty));
  }

  void _startTicker() {
    _ticker?.cancel();
    _tickNow();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tickNow());
  }

  void _tickNow() {
    if (_disposed) {
      return;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(now: DateTime.now()));
  }

  Future<void> _loadSchedule() async {
    await runAsyncLoad<ScheduleModel, List<RacesModel>>(
      fetch: _fetchSchedule,
      getField: () => _holder.viewModel.racesElements,
      setField: (value) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(_holder.viewModel.copyWith(racesElements: value));
      },
      onSuccess: (data) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(
          _holder.viewModel.copyWith(
            racesElements: _holder.viewModel.racesElements.toValue(data!.raceTable.races),
            showingCachedData: _lastOfflineFallback,
          ),
        );
      },
    );
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
