import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_page_view_model.freezed.dart';

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

/// UI-состояние экрана расписания.
@freezed
abstract class SchedulePageViewModel with _$SchedulePageViewModel {
  const SchedulePageViewModel._();

  const factory SchedulePageViewModel({
    /// Текущее время для countdown'а.
    required DateTime now,
    /// Выбранная дата в календаре.
    required DateTime selectedDate,
    /// Видимый месяц в календаре.
    required DateTime focusedDate,
    /// Раунды сезона.
    @Default(Loadable.loading()) Loadable<List<RacesModel>> racesElements,
    /// Все данные загружены.
    @Default(false) bool allDataIsLoaded,
    /// Расписание выбранного дня.
    @Default(ScheduleSelectedDay.empty) ScheduleSelectedDay selectedDay,
    /// Показываем кэшированные данные (офлайн).
    @Default(false) bool showingCachedData,
  }) = _SchedulePageViewModel;

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
}
