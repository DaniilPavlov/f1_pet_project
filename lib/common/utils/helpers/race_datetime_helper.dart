import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';

/// Конвертация UTC-дат сессий Ergast/Jolpica в локальное время устройства.
abstract final class RaceDateTimeHelper {
  /// Парсит [RaceDateModel] (дата + время в UTC) в [DateTime] локального пояса.
  ///
  /// Пустое [RaceDateModel.time] трактуется как полночь UTC указанного дня.
  static DateTime toLocal(RaceDateModel date) {
    final timePart = date.time.trim().isEmpty ? '00:00:00' : date.time.trim();
    final normalized = timePart.endsWith('Z') ? timePart.substring(0, timePart.length - 1) : timePart;
    final utc = DateTime.parse('${date.date}T${normalized}Z');
    return utc.toLocal();
  }

  /// Локальное время старта основной гонки.
  static DateTime raceLocal(RacesModel race) {
    return toLocal(RaceDateModel(date: race.date, time: race.time ?? ''));
  }

  /// Цель countdown: FP1, иначе первая доступная сессия, иначе гонка.
  static DateTime countdownTarget(RacesModel race) {
    for (final session in _orderedSessions(race)) {
      if (session != null) {
        return toLocal(session);
      }
    }
    return raceLocal(race);
  }

  /// Гонка ещё не стартовала (по времени race).
  static bool isUpcoming(RacesModel race, DateTime now) => raceLocal(race).isAfter(now);

  /// Начало уикенда (первая сессия или гонка).
  static DateTime weekendStart(RacesModel race) => countdownTarget(race);

  static List<RaceDateModel?> _orderedSessions(RacesModel race) => [
    race.firstPractice,
    race.secondPractice,
    race.thirdPractice,
    race.sprintQualifying,
    race.sprint,
    race.qualifying,
  ];
}

/// Разбивка оставшегося времени до события.
class CountdownParts {
  const CountdownParts({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  factory CountdownParts.until(DateTime target, DateTime now) {
    var diff = target.difference(now);
    if (diff.isNegative) {
      return CountdownParts.zero;
    }
    final days = diff.inDays;
    diff -= Duration(days: days);
    final hours = diff.inHours;
    diff -= Duration(hours: hours);
    final minutes = diff.inMinutes;
    diff -= Duration(minutes: minutes);
    return CountdownParts(days: days, hours: hours, minutes: minutes, seconds: diff.inSeconds);
  }

  static const zero = CountdownParts(days: 0, hours: 0, minutes: 0, seconds: 0);

  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  bool get isZero => days == 0 && hours == 0 && minutes == 0 && seconds == 0;
}
