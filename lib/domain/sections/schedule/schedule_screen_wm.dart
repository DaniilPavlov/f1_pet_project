// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/sections/schedule/race_date_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/schedule/schedule_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/schedule/schedule_screen.dart';
import 'package:f1_pet_project/presentation/sections/schedule/widgets/schedule_container.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreenWM extends WidgetModel<ScheduleScreen, ScheduleScreenModel>
    implements IScheduleScreenWM {
  ScheduleScreenWM(super._model);
  final _scrollController = ScrollController();

  final _racesElements = EntityStateNotifier<List<RacesModel>>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  final _selectedDate = StateNotifier<DateTime>(initValue: DateTime.now());

  final _screenError = StateNotifier<CustomException?>();

  final _scheduleOfSelectedDate = StateNotifier<List<Widget>>(initValue: []);

  DateTime focusedDate = DateTime.now();

  @override
  ValueListenable<EntityState<List<RacesModel>>> get racesElements =>
      _racesElements;

  @override
  ListenableState<DateTime> get selectedDate => _selectedDate;

  @override
  ListenableState<List<Widget>> get scheduleOfSelectedDate =>
      _scheduleOfSelectedDate;

  @override
  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  @override
  ListenableState<CustomException?> get screenError => _screenError;

  @override
  ScrollController get scrollController => _scrollController;

  @override
  void initWidgetModel() {
    loadAllData();

    super.initWidgetModel();
  }

  @override
  void onSelectDay(DateTime selectedDate, DateTime _) {
    _selectedDate.accept(selectedDate);
    _showscheduleOfSelectedDate();
  }

  @override
  String? getLogoPath(DateTime day) {
    if (_racesElements.value.data!
        .any((race) => isSameDay(DateTime.parse(race.date), day))) {
      return 'assets/calendar/finish.png';
    }
    if (_racesElements.value.data!.any(
      (race) => race.firstPractice != null
          ? isSameDay(
              DateTime.parse(race.firstPractice!.date),
              day,
            )
          : false,
    )) {
      return 'assets/calendar/car.png';
    }

    if (_racesElements.value.data!.any(
      (race) => race.secondPractice != null
          ? isSameDay(
              DateTime.parse(race.secondPractice!.date),
              day,
            )
          : false,
    )) {
      return 'assets/calendar/car.png';
    }

    if (_racesElements.value.data!.any(
      (race) => race.qualifying != null
          ? isSameDay(
              DateTime.parse(race.qualifying!.date),
              day,
            )
          : false,
    )) {
      return 'assets/calendar/car.png';
    }

    if (_racesElements.value.data!.any(
      (race) => race.thirdPractice != null
          ? isSameDay(
              DateTime.parse(race.thirdPractice!.date),
              day,
            )
          : false,
    )) {
      return 'assets/calendar/car.png';
    }

    if (_racesElements.value.data!.any(
      (race) => race.sprint != null
          ? isSameDay(
              DateTime.parse(race.sprint!.date),
              day,
            )
          : false,
    )) {
      return 'assets/calendar/car.png';
    }
    return null;
  }

  @override
  Future<void> loadAllData() async {
    _screenError.accept(null);
    _allDataIsLoaded.accept(false);

    await Future.wait(
      [
        _loadSchedule(),
      ],
    );

    if (_screenError.value == null) {
      onSelectDay(DateTime.now(), DateTime.now());
    }

    _allDataIsLoaded.accept(true);
  }

  /// Shows schedule of selected date.
  void _showscheduleOfSelectedDate() {
    _scheduleOfSelectedDate.accept([]);

    final newSchedule = <Widget>[];
    for (var i = 0; i < _racesElements.value.data!.length; i++) {
      final race = _racesElements.value.data![i];
      if (isSameDay(DateTime.parse(race.date), _selectedDate.value) ||
          DateTime.parse(race.date).isAfter(_selectedDate.value!)) {
        if (race.firstPractice != null &&
            isSameDay(
              DateTime.parse(race.firstPractice!.date),
              _selectedDate.value,
            )) {
          newSchedule.add(
            ScheduleContainer(
              title: 'Первая практика',
              date: race.firstPractice!,
            ),
          );
        }

        if (race.secondPractice != null &&
            isSameDay(
              DateTime.parse(race.secondPractice!.date),
              _selectedDate.value,
            )) {
          newSchedule.add(
            ScheduleContainer(
              title: 'Вторая практика',
              date: race.secondPractice!,
            ),
          );
        }

        if (race.thirdPractice != null &&
            isSameDay(
              DateTime.parse(race.thirdPractice!.date),
              _selectedDate.value,
            )) {
          newSchedule.add(
            ScheduleContainer(
              title: 'Третья практика',
              date: race.thirdPractice!,
            ),
          );
        }
        if (race.sprint != null &&
            isSameDay(
              DateTime.parse(race.sprint!.date),
              _selectedDate.value,
            )) {
          newSchedule.add(
            ScheduleContainer(
              title: 'Спринт',
              date: race.sprint!,
            ),
          );
        }

        if (race.qualifying != null &&
            isSameDay(
              DateTime.parse(race.qualifying!.date),
              _selectedDate.value,
            )) {
          newSchedule.add(
            ScheduleContainer(
              title: 'Квалификация',
              date: race.qualifying!,
            ),
          );
        }

        if (isSameDay(DateTime.parse(race.date), _selectedDate.value)) {
          newSchedule.add(
            ScheduleContainer(
              title: 'Гонка',
              date: RaceDateModel(date: race.date, time: race.time ?? ''),
            ),
          );
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

  /// Loads schedule.
  Future<void> _loadSchedule() async {
    await execute<ScheduleModel>(
      model.loadSchedule,
      before: _racesElements.loading,
      onSuccess: (data) {
        _racesElements.content(data!.raceTable.races);
      },
      onError: (value) {
        _screenError.accept(value);
        _racesElements.error(value);
      },
    );
  }

  /// Scrolls to schedule.
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

abstract interface class IScheduleScreenWM implements IWidgetModel {
  /// Returns screen scroll controller.
  ScrollController get scrollController;

  /// Returns schedule.
  ValueListenable<EntityState<List<RacesModel>>> get racesElements;

  /// Returns is all data loaded.
  ListenableState<bool> get allDataIsLoaded;

  /// Returns selected date.
  ListenableState<DateTime> get selectedDate;

  /// Returns schedule of selected date.
  ListenableState<List<Widget>> get scheduleOfSelectedDate;

  /// Returns error.
  ListenableState<CustomException?> get screenError;

  /// Invokes on day selection.
  void onSelectDay(DateTime _, DateTime __);

  /// Loads all data.
  void loadAllData();

  /// Returns logo.
  String? getLogoPath(DateTime day);
}
