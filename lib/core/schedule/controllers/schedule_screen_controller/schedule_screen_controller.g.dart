// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ScheduleScreenController on ScheduleScreenControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'ScheduleScreenControllerBase.screenError',
      )).value;
  Computed<bool>? _$selectedDayHasSessionsComputed;

  @override
  bool get selectedDayHasSessions =>
      (_$selectedDayHasSessionsComputed ??= Computed<bool>(
        () => super.selectedDayHasSessions,
        name: 'ScheduleScreenControllerBase.selectedDayHasSessions',
      )).value;
  Computed<RacesModel?>? _$upcomingRaceComputed;

  @override
  RacesModel? get upcomingRace =>
      (_$upcomingRaceComputed ??= Computed<RacesModel?>(
        () => super.upcomingRace,
        name: 'ScheduleScreenControllerBase.upcomingRace',
      )).value;
  Computed<CountdownParts>? _$upcomingCountdownComputed;

  @override
  CountdownParts get upcomingCountdown =>
      (_$upcomingCountdownComputed ??= Computed<CountdownParts>(
        () => super.upcomingCountdown,
        name: 'ScheduleScreenControllerBase.upcomingCountdown',
      )).value;

  late final _$racesElementsAtom = Atom(
    name: 'ScheduleScreenControllerBase.racesElements',
    context: context,
  );

  @override
  AsyncValue<List<RacesModel>> get racesElements {
    _$racesElementsAtom.reportRead();
    return super.racesElements;
  }

  @override
  set racesElements(AsyncValue<List<RacesModel>> value) {
    _$racesElementsAtom.reportWrite(value, super.racesElements, () {
      super.racesElements = value;
    });
  }

  late final _$allDataIsLoadedAtom = Atom(
    name: 'ScheduleScreenControllerBase.allDataIsLoaded',
    context: context,
  );

  @override
  bool get allDataIsLoaded {
    _$allDataIsLoadedAtom.reportRead();
    return super.allDataIsLoaded;
  }

  @override
  set allDataIsLoaded(bool value) {
    _$allDataIsLoadedAtom.reportWrite(value, super.allDataIsLoaded, () {
      super.allDataIsLoaded = value;
    });
  }

  late final _$nowAtom = Atom(
    name: 'ScheduleScreenControllerBase.now',
    context: context,
  );

  @override
  DateTime get now {
    _$nowAtom.reportRead();
    return super.now;
  }

  @override
  set now(DateTime value) {
    _$nowAtom.reportWrite(value, super.now, () {
      super.now = value;
    });
  }

  late final _$selectedDateAtom = Atom(
    name: 'ScheduleScreenControllerBase.selectedDate',
    context: context,
  );

  @override
  DateTime get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  late final _$scheduleOfSelectedDateAtom = Atom(
    name: 'ScheduleScreenControllerBase.scheduleOfSelectedDate',
    context: context,
  );

  @override
  ObservableList<Widget> get scheduleOfSelectedDate {
    _$scheduleOfSelectedDateAtom.reportRead();
    return super.scheduleOfSelectedDate;
  }

  @override
  set scheduleOfSelectedDate(ObservableList<Widget> value) {
    _$scheduleOfSelectedDateAtom.reportWrite(
      value,
      super.scheduleOfSelectedDate,
      () {
        super.scheduleOfSelectedDate = value;
      },
    );
  }

  late final _$loadAllDataAsyncAction = AsyncAction(
    'ScheduleScreenControllerBase.loadAllData',
    context: context,
  );

  @override
  Future<void> loadAllData() {
    return _$loadAllDataAsyncAction.run(() => super.loadAllData());
  }

  late final _$refreshAllAsyncAction = AsyncAction(
    'ScheduleScreenControllerBase.refreshAll',
    context: context,
  );

  @override
  Future<void> refreshAll() {
    return _$refreshAllAsyncAction.run(() => super.refreshAll());
  }

  late final _$_loadScheduleAsyncAction = AsyncAction(
    'ScheduleScreenControllerBase._loadSchedule',
    context: context,
  );

  @override
  Future<void> _loadSchedule() {
    return _$_loadScheduleAsyncAction.run(() => super._loadSchedule());
  }

  late final _$ScheduleScreenControllerBaseActionController = ActionController(
    name: 'ScheduleScreenControllerBase',
    context: context,
  );

  @override
  void onSelectDay(DateTime newSelectedDate, DateTime focusedDay) {
    final _$actionInfo = _$ScheduleScreenControllerBaseActionController
        .startAction(name: 'ScheduleScreenControllerBase.onSelectDay');
    try {
      return super.onSelectDay(newSelectedDate, focusedDay);
    } finally {
      _$ScheduleScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _showScheduleOfSelectedDate() {
    final _$actionInfo = _$ScheduleScreenControllerBaseActionController
        .startAction(
          name: 'ScheduleScreenControllerBase._showScheduleOfSelectedDate',
        );
    try {
      return super._showScheduleOfSelectedDate();
    } finally {
      _$ScheduleScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _tickNow() {
    final _$actionInfo = _$ScheduleScreenControllerBaseActionController
        .startAction(name: 'ScheduleScreenControllerBase._tickNow');
    try {
      return super._tickNow();
    } finally {
      _$ScheduleScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
racesElements: ${racesElements},
allDataIsLoaded: ${allDataIsLoaded},
now: ${now},
selectedDate: ${selectedDate},
scheduleOfSelectedDate: ${scheduleOfSelectedDate},
screenError: ${screenError},
selectedDayHasSessions: ${selectedDayHasSessions},
upcomingRace: ${upcomingRace},
upcomingCountdown: ${upcomingCountdown}
    ''';
  }
}
