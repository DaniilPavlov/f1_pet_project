// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/race_date_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/schedule/schedule_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/schedule/schedule_screen.dart';
import 'package:f1_pet_project/presentation/sections/schedule/widgets/schedule_container.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class IScheduleScreenWM extends IWidgetModel {
  /// скролл страницы
  ScrollController get scrollController;

  /// расписание
  ListenableState<EntityState<List<RacesModel>>> get racesElements;

  /// загружены ли начальные данные
  ListenableState<bool> get allDataIsLoaded;

  /// выбранная дата календаря
  ListenableState<DateTime> get selectedDate;

  /// расписание выбранной даты
  ListenableState<List<Widget>> get scheduleOfSelectedDate;

  /// показ расписания при выборе даты
  void onSelectDay(DateTime _, DateTime __);

  /// загрузка расписания сезона
  void loadSchedule();

  /// логотип события
  String? getLogoPath(DateTime day);

  /// загрузка всех данных
  void loadAllData();
}

class ScheduleScreenWM extends WidgetModel<ScheduleScreen, ScheduleScreenModel>
    implements IScheduleScreenWM {
  final _scrollController = ScrollController();
  final _racesElements = EntityStateNotifier<List<RacesModel>>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  final _selectedDate = StateNotifier<DateTime>(initValue: DateTime.now());

  final _scheduleOfSelectedDate = StateNotifier<List<Widget>>(initValue: []);

  DateTime focusedDate = DateTime.now();

  @override
  ListenableState<EntityState<List<RacesModel>>> get racesElements =>
      _racesElements;

  @override
  ListenableState<DateTime> get selectedDate => _selectedDate;

  @override
  ListenableState<List<Widget>> get scheduleOfSelectedDate =>
      _scheduleOfSelectedDate;

  @override
  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  @override
  ScrollController get scrollController => _scrollController;

  ScheduleScreenWM(super.model);

  @override
  void initWidgetModel() {
    loadAllData();

    super.initWidgetModel();
  }

  @override
  Future<void> loadSchedule() async {
    await execute<ScheduleModel>(
      model.loadSchedule,
      before: _racesElements.loading,
      onSuccess: (data) {
        _racesElements.content(data!.RaceTable.Races);
      },
      onError: _racesElements.error,
    );
  }

  @override
  Future<void> loadAllData() async {
    _allDataIsLoaded.accept(false);

    await Future.wait(
      [
        loadSchedule(),
      ],
    );

    _allDataIsLoaded.accept(true);
  }

  @override
  void onSelectDay(DateTime selectedDate, DateTime _) {
    //    if (selectedDate == _selectedDate.value ||
    //     selectedDate.month == focusedDate.month) {

    // }

    _selectedDate.accept(selectedDate);
    _showscheduleOfSelectedDate();
  }

  @override
  String? getLogoPath(DateTime day) {
    if (_racesElements.value!.data!
        .any((race) => isSameDay(DateTime.parse(race.date), day))) {
      return 'assets/calendar/finish.png';
    }
    if (_racesElements.value!.data!.any((race) => race.FirstPractice != null
        ? isSameDay(
            DateTime.parse(race.FirstPractice!.date),
            day,
          )
        : false)) {
      return 'assets/calendar/car.png';
    }

    if (_racesElements.value!.data!.any((race) => race.SecondPractice != null
        ? isSameDay(
            DateTime.parse(race.SecondPractice!.date),
            day,
          )
        : false)) {
      return 'assets/calendar/car.png';
    }

    if (_racesElements.value!.data!.any((race) => race.Qualifying != null
        ? isSameDay(
            DateTime.parse(race.Qualifying!.date),
            day,
          )
        : false)) {
      return 'assets/calendar/car.png';
    }

    if (_racesElements.value!.data!.any((race) => race.ThirdPractice != null
        ? isSameDay(
            DateTime.parse(race.ThirdPractice!.date),
            day,
          )
        : false)) {
      return 'assets/calendar/car.png';
    }

    if (_racesElements.value!.data!.any((race) => race.Sprint != null
        ? isSameDay(
            DateTime.parse(race.Sprint!.date),
            day,
          )
        : false)) {
      return 'assets/calendar/car.png';
    }
    return null;
  }

  /// Показывает расписание выбранной даты
  void _showscheduleOfSelectedDate() {
    _scheduleOfSelectedDate.accept([]);

    final newSchedule = <Widget>[];
    for (var i = 0; i < _racesElements.value!.data!.length; i++) {
      final race = _racesElements.value!.data![i];
      if (isSameDay(DateTime.parse(race.date), _selectedDate.value) ||
          DateTime.parse(race.date).isAfter(_selectedDate.value!)) {
        if (race.FirstPractice != null &&
            isSameDay(
              DateTime.parse(race.FirstPractice!.date),
              _selectedDate.value,
            )) {
          newSchedule.add(ScheduleContainer(
            title: 'Первая практика',
            date: race.FirstPractice!,
          ));
        }

        if (race.SecondPractice != null &&
            isSameDay(
              DateTime.parse(race.SecondPractice!.date),
              _selectedDate.value,
            )) {
          newSchedule.add(ScheduleContainer(
            title: 'Вторая практика',
            date: race.SecondPractice!,
          ));
        }

        if (race.ThirdPractice != null &&
            isSameDay(
              DateTime.parse(race.ThirdPractice!.date),
              _selectedDate.value,
            )) {
          newSchedule.add(ScheduleContainer(
            title: 'Третья практика',
            date: race.ThirdPractice!,
          ));
        }
        if (race.Sprint != null &&
            isSameDay(
              DateTime.parse(race.Sprint!.date),
              _selectedDate.value,
            )) {
          newSchedule.add(ScheduleContainer(
            title: 'Спринт',
            date: race.Sprint!,
          ));
        }

        if (race.Qualifying != null &&
            isSameDay(
              DateTime.parse(race.Qualifying!.date),
              _selectedDate.value,
            )) {
          newSchedule.add(ScheduleContainer(
            title: 'Квалификация',
            date: race.Qualifying!,
          ));
        }

        if (isSameDay(DateTime.parse(race.date), _selectedDate.value)) {
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
                race.Circuit.circuitName,
                style: AppStyles.h3,
              ),
            ),
          );
        }

        _scheduleOfSelectedDate.accept(newSchedule);
        if (newSchedule.isNotEmpty) {
          Future<void>.delayed(
            const Duration(
              milliseconds: 100,
            ),
            _animateToSchedule,
          );
        }
        break;
      }
    }
  }

  /// Скролл к расписанию
  void _animateToSchedule() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(
        milliseconds: 200,
      ),
      curve: Curves.easeOutCubic,
    );
  }
}

ScheduleScreenWM createScheduleScreenWM(BuildContext _) =>
    ScheduleScreenWM(ScheduleScreenModel());
