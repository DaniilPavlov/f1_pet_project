// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/fetch_from_loader.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/scroll_controller_extension.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/core/schedule/components/schedule_container.dart';
import 'package:f1_pet_project/core/schedule/loaders/schedule_loader.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:table_calendar/table_calendar.dart';

part 'schedule_screen_controller.g.dart';

/// MobX-контроллер экрана расписания.
class ScheduleScreenController = ScheduleScreenControllerBase with _$ScheduleScreenController;

/// Управляет загрузкой расписания, календарём и списком сессий выбранного дня.
abstract class ScheduleScreenControllerBase with Store {
  ScheduleScreenControllerBase({required this.l10n, Future<ScheduleModel> Function()? fetchSchedule})
    : _fetchScheduleOverride = fetchSchedule;

  final AppLocalizations l10n;
  final Future<ScheduleModel> Function()? _fetchScheduleOverride;

  final scrollController = ScrollController();

  @observable
  AsyncValue<List<RacesModel>> racesElements = const AsyncValue.loading();

  @observable
  bool allDataIsLoaded = false;

  @observable
  DateTime selectedDate = DateTime.now();

  @observable
  ObservableList<Widget> scheduleOfSelectedDate = ObservableList<Widget>();

  @computed
  CustomException? get screenError => racesElements.exception;

  /// Освобождает [scrollController] при уничтожении контроллера.
  void dispose() {
    scrollController.dispose();
  }

  /// Загружает расписание сезона и выбирает текущий день.
  @action
  Future<void> loadAllData() async {
    allDataIsLoaded = false;
    await _loadSchedule();

    if (screenError == null) {
      onSelectDay(DateTime.now(), DateTime.now());
    }

    allDataIsLoaded = screenError == null;
  }

  /// Обрабатывает выбор даты в календаре и обновляет список сессий.
  @action
  void onSelectDay(DateTime newSelectedDate, DateTime focusedDay) {
    selectedDate = newSelectedDate;
    _showScheduleOfSelectedDate();
  }

  /// Возвращает иконку для дня с гонкой или сессией, иначе null.
  String? getLogoPath(DateTime day) {
    final races = racesElements.value;
    if (races == null) return null;

    if (races.any((race) => isSameDay(DateTime.parse(race.date), day))) {
      return 'assets/calendar/finish.png';
    }
    if (races.any((race) => _hasSessionOnDay(race, day))) {
      return 'assets/calendar/car.png';
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

  void _addSessionsForDay(RacesModel race, DateTime day, List<Widget> schedule) {
    final sessions = [
      (race.firstPractice, l10n.firstPractice),
      (race.secondPractice, l10n.secondPractice),
      (race.thirdPractice, l10n.thirdPractice),
      (race.sprintQualifying, l10n.sprintQualifying),
      (race.sprint, l10n.sprint),
      (race.qualifying, l10n.qualifying),
    ];

    for (final (session, title) in sessions) {
      if (session != null && isSameDay(DateTime.parse(session.date), day)) {
        schedule.add(ScheduleContainer(title: title, date: session));
      }
    }
  }

  @action
  void _showScheduleOfSelectedDate() {
    scheduleOfSelectedDate.clear();

    final races = racesElements.value;
    if (races == null) return;

    final newSchedule = <Widget>[];
    for (var i = 0; i < races.length; i++) {
      final race = races[i];
      if (isSameDay(DateTime.parse(race.date), selectedDate) || DateTime.parse(race.date).isAfter(selectedDate)) {
        _addSessionsForDay(race, selectedDate, newSchedule);
        if (isSameDay(DateTime.parse(race.date), selectedDate)) {
          newSchedule.add(
            ScheduleContainer(
              title: l10n.race,
              date: RaceDateModel(date: race.date, time: race.time ?? ''),
            ),
          );
        }
        if (newSchedule.isNotEmpty) {
          newSchedule.insert(
            0,
            Padding(
              padding: const EdgeInsets.only(bottom: StaticData.defaultHorizontalPadding),
              child: Text(race.raceName, style: AppStyles.h3),
            ),
          );
        }

        scheduleOfSelectedDate.replaceRange(0, scheduleOfSelectedDate.length, newSchedule);
        if (newSchedule.isNotEmpty) {
          Future<void>.delayed(const Duration(milliseconds: 100), scrollController.animateToBottom);
        }
        break;
      }
    }
  }

  @action
  Future<void> _loadSchedule() async {
    await runAsyncLoad<ScheduleModel, List<RacesModel>>(
      fetch: _fetchSchedule,
      getField: () => racesElements,
      setField: (value) => racesElements = value,
      onSuccess: (data) => racesElements = racesElements.toValue(data!.raceTable.races),
    );
  }

  Future<ScheduleModel> _fetchSchedule() =>
      fetchFromLoader(override: _fetchScheduleOverride, load: ScheduleLoader.loadData, parse: ScheduleModel.fromJson);
}
