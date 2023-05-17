// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:f1_pet_project/data/models/sections/schedule/race_date_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/domain/sections/schedule/schedule_repository.dart';
import 'package:f1_pet_project/presentation/sections/schedule/widgets/schedule_container.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

final scheduleRacesProvider = StateProvider<List<RacesModel>?>((ref) {
  return null;
});

final scheduleRaceWidgetsProvider = StateProvider<List<Widget>?>((ref) {
  return null;
});

final scheduleSelectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final fetchScheduleOfSelectedDateProvider =
    Provider.family<List<Widget>, DateTime>((ref, date) {
  final raceWidgets = <Widget>[];
  final races = ref.read(scheduleRacesProvider);

  final newSchedule = <Widget>[];
  for (var i = 0; i < races!.length; i++) {
    final race = races[i];
    if (isSameDay(DateTime.parse(race.date), date) ||
        DateTime.parse(race.date).isAfter(date)) {
      if (race.FirstPractice != null &&
          isSameDay(
            DateTime.parse(race.FirstPractice!.date),
            date,
          )) {
        newSchedule.add(ScheduleContainer(
          title: 'Первая практика',
          date: race.FirstPractice!,
        ));
      }

      if (race.SecondPractice != null &&
          isSameDay(
            DateTime.parse(race.SecondPractice!.date),
            date,
          )) {
        newSchedule.add(ScheduleContainer(
          title: 'Вторая практика',
          date: race.SecondPractice!,
        ));
      }

      if (race.ThirdPractice != null &&
          isSameDay(
            DateTime.parse(race.ThirdPractice!.date),
            date,
          )) {
        newSchedule.add(ScheduleContainer(
          title: 'Третья практика',
          date: race.ThirdPractice!,
        ));
      }
      if (race.Sprint != null &&
          isSameDay(
            DateTime.parse(race.Sprint!.date),
            date,
          )) {
        newSchedule.add(ScheduleContainer(
          title: 'Спринт',
          date: race.Sprint!,
        ));
      }

      if (race.Qualifying != null &&
          isSameDay(
            DateTime.parse(race.Qualifying!.date),
            date,
          )) {
        newSchedule.add(ScheduleContainer(
          title: 'Квалификация',
          date: race.Qualifying!,
        ));
      }

      if (isSameDay(DateTime.parse(race.date), date)) {
        newSchedule.add(ScheduleContainer(
          title: 'Гонка',
          date: RaceDateModel(date: race.date, time: race.time ?? ''),
        ));
      }
      if (newSchedule.isNotEmpty) {
        newSchedule.insert(
          0,
          Padding(
            padding: const EdgeInsets.only(
              bottom: StaticData.defaultHorizontalPadding,
            ),
            child: Text(
              race.raceName,
              style: AppStyles.h3,
            ),
          ),
        );
      }
      raceWidgets.addAll(newSchedule);
      break;
    }
  }
  // TODO(info): Providers are not allowed to modify other providers during their initialization.
  // ref.read(scheduleRaceWidgetsProvider.notifier).state = scheduleOfSelectedDate;
  return raceWidgets;
});

final scheduleDayLogoProvider = Provider.family<String?, DateTime>((ref, day) {
  final races = ref.read(scheduleRacesProvider);

  if (races!.any((race) => isSameDay(DateTime.parse(race.date), day))) {
    return 'assets/calendar/finish.png';
  }
  if (races.any((race) => race.FirstPractice != null
      ? isSameDay(
          DateTime.parse(race.FirstPractice!.date),
          day,
        )
      : false)) {
    return 'assets/calendar/car.png';
  }

  if (races.any((race) => race.SecondPractice != null
      ? isSameDay(
          DateTime.parse(race.SecondPractice!.date),
          day,
        )
      : false)) {
    return 'assets/calendar/car.png';
  }

  if (races.any((race) => race.Qualifying != null
      ? isSameDay(
          DateTime.parse(race.Qualifying!.date),
          day,
        )
      : false)) {
    return 'assets/calendar/car.png';
  }

  if (races.any((race) => race.ThirdPractice != null
      ? isSameDay(
          DateTime.parse(race.ThirdPractice!.date),
          day,
        )
      : false)) {
    return 'assets/calendar/car.png';
  }

  if (races.any((race) => race.Sprint != null
      ? isSameDay(
          DateTime.parse(race.Sprint!.date),
          day,
        )
      : false)) {
    return 'assets/calendar/car.png';
  }
  return null;
});

final scheduleInitDataProvider =
    FutureProvider.autoDispose<List<RacesModel>?>((ref) async {
  final scheduleRepository = ref.read(scheduleRepositoryProvider);
  final result = await scheduleRepository.loadSchedule();
  ref.read(scheduleRacesProvider.notifier).state = result;
  ref.read(scheduleRaceWidgetsProvider.notifier).state =
      ref.read(fetchScheduleOfSelectedDateProvider(DateTime.now()));
  return result;
});

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepository();
});
