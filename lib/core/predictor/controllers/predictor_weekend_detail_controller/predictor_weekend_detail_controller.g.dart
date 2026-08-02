// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predictor_weekend_detail_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PredictorWeekendDetailController
    on PredictorWeekendDetailControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'PredictorWeekendDetailControllerBase.screenError',
      )).value;
  Computed<PredictorSessionCompare?>? _$activeCompareComputed;

  @override
  PredictorSessionCompare? get activeCompare =>
      (_$activeCompareComputed ??= Computed<PredictorSessionCompare?>(
        () => super.activeCompare,
        name: 'PredictorWeekendDetailControllerBase.activeCompare',
      )).value;

  late final _$qualifyingCompareAtom = Atom(
    name: 'PredictorWeekendDetailControllerBase.qualifyingCompare',
    context: context,
  );

  @override
  AsyncValue<PredictorSessionCompare> get qualifyingCompare {
    _$qualifyingCompareAtom.reportRead();
    return super.qualifyingCompare;
  }

  @override
  set qualifyingCompare(AsyncValue<PredictorSessionCompare> value) {
    _$qualifyingCompareAtom.reportWrite(value, super.qualifyingCompare, () {
      super.qualifyingCompare = value;
    });
  }

  late final _$raceCompareAtom = Atom(
    name: 'PredictorWeekendDetailControllerBase.raceCompare',
    context: context,
  );

  @override
  AsyncValue<PredictorSessionCompare> get raceCompare {
    _$raceCompareAtom.reportRead();
    return super.raceCompare;
  }

  @override
  set raceCompare(AsyncValue<PredictorSessionCompare> value) {
    _$raceCompareAtom.reportWrite(value, super.raceCompare, () {
      super.raceCompare = value;
    });
  }

  late final _$driversByIdAtom = Atom(
    name: 'PredictorWeekendDetailControllerBase.driversById',
    context: context,
  );

  @override
  ObservableMap<String, DriverModel> get driversById {
    _$driversByIdAtom.reportRead();
    return super.driversById;
  }

  @override
  set driversById(ObservableMap<String, DriverModel> value) {
    _$driversByIdAtom.reportWrite(value, super.driversById, () {
      super.driversById = value;
    });
  }

  late final _$selectedSessionAtom = Atom(
    name: 'PredictorWeekendDetailControllerBase.selectedSession',
    context: context,
  );

  @override
  PredictorDetailSession get selectedSession {
    _$selectedSessionAtom.reportRead();
    return super.selectedSession;
  }

  @override
  set selectedSession(PredictorDetailSession value) {
    _$selectedSessionAtom.reportWrite(value, super.selectedSession, () {
      super.selectedSession = value;
    });
  }

  late final _$allDataIsLoadedAtom = Atom(
    name: 'PredictorWeekendDetailControllerBase.allDataIsLoaded',
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

  late final _$loadAsyncAction = AsyncAction(
    'PredictorWeekendDetailControllerBase.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$_loadDriversMapAsyncAction = AsyncAction(
    'PredictorWeekendDetailControllerBase._loadDriversMap',
    context: context,
  );

  @override
  Future<void> _loadDriversMap() {
    return _$_loadDriversMapAsyncAction.run(() => super._loadDriversMap());
  }

  late final _$_loadQualifyingAsyncAction = AsyncAction(
    'PredictorWeekendDetailControllerBase._loadQualifying',
    context: context,
  );

  @override
  Future<void> _loadQualifying() {
    return _$_loadQualifyingAsyncAction.run(() => super._loadQualifying());
  }

  late final _$_loadRaceAsyncAction = AsyncAction(
    'PredictorWeekendDetailControllerBase._loadRace',
    context: context,
  );

  @override
  Future<void> _loadRace() {
    return _$_loadRaceAsyncAction.run(() => super._loadRace());
  }

  late final _$PredictorWeekendDetailControllerBaseActionController =
      ActionController(
        name: 'PredictorWeekendDetailControllerBase',
        context: context,
      );

  @override
  void selectSession(PredictorDetailSession session) {
    final _$actionInfo = _$PredictorWeekendDetailControllerBaseActionController
        .startAction(
          name: 'PredictorWeekendDetailControllerBase.selectSession',
        );
    try {
      return super.selectSession(session);
    } finally {
      _$PredictorWeekendDetailControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  Future<void> refreshAll() {
    final _$actionInfo = _$PredictorWeekendDetailControllerBaseActionController
        .startAction(name: 'PredictorWeekendDetailControllerBase.refreshAll');
    try {
      return super.refreshAll();
    } finally {
      _$PredictorWeekendDetailControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  String toString() {
    return '''
qualifyingCompare: ${qualifyingCompare},
raceCompare: ${raceCompare},
driversById: ${driversById},
selectedSession: ${selectedSession},
allDataIsLoaded: ${allDataIsLoaded},
screenError: ${screenError},
activeCompare: ${activeCompare}
    ''';
  }
}
