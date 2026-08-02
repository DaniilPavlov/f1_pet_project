// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predictor_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PredictorScreenController on PredictorScreenControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'PredictorScreenControllerBase.screenError',
      )).value;
  Computed<String?>? _$seasonYearComputed;

  @override
  String? get seasonYear => (_$seasonYearComputed ??= Computed<String?>(
    () => super.seasonYear,
    name: 'PredictorScreenControllerBase.seasonYear',
  )).value;
  Computed<int>? _$seasonTotalPointsComputed;

  @override
  int get seasonTotalPoints => (_$seasonTotalPointsComputed ??= Computed<int>(
    () => super.seasonTotalPoints,
    name: 'PredictorScreenControllerBase.seasonTotalPoints',
  )).value;
  Computed<RacesModel?>? _$upcomingRaceComputed;

  @override
  RacesModel? get upcomingRace =>
      (_$upcomingRaceComputed ??= Computed<RacesModel?>(
        () => super.upcomingRace,
        name: 'PredictorScreenControllerBase.upcomingRace',
      )).value;
  Computed<DateTime?>? _$lockAtComputed;

  @override
  DateTime? get lockAt => (_$lockAtComputed ??= Computed<DateTime?>(
    () => super.lockAt,
    name: 'PredictorScreenControllerBase.lockAt',
  )).value;
  Computed<bool>? _$isLockedComputed;

  @override
  bool get isLocked => (_$isLockedComputed ??= Computed<bool>(
    () => super.isLocked,
    name: 'PredictorScreenControllerBase.isLocked',
  )).value;
  Computed<bool>? _$missingQualifyingTimeComputed;

  @override
  bool get missingQualifyingTime =>
      (_$missingQualifyingTimeComputed ??= Computed<bool>(
        () => super.missingQualifyingTime,
        name: 'PredictorScreenControllerBase.missingQualifyingTime',
      )).value;
  Computed<CountdownParts>? _$lockCountdownComputed;

  @override
  CountdownParts get lockCountdown =>
      (_$lockCountdownComputed ??= Computed<CountdownParts>(
        () => super.lockCountdown,
        name: 'PredictorScreenControllerBase.lockCountdown',
      )).value;
  Computed<PredictorWeekendPrediction?>? _$currentPredictionComputed;

  @override
  PredictorWeekendPrediction? get currentPrediction =>
      (_$currentPredictionComputed ??= Computed<PredictorWeekendPrediction?>(
        () => super.currentPrediction,
        name: 'PredictorScreenControllerBase.currentPrediction',
      )).value;
  Computed<List<PredictorWeekendPrediction>>? _$historyWeekendsComputed;

  @override
  List<PredictorWeekendPrediction> get historyWeekends =>
      (_$historyWeekendsComputed ??= Computed<List<PredictorWeekendPrediction>>(
        () => super.historyWeekends,
        name: 'PredictorScreenControllerBase.historyWeekends',
      )).value;
  Computed<List<PredictorSeasonSummary>>? _$archivedSeasonSummariesComputed;

  @override
  List<PredictorSeasonSummary> get archivedSeasonSummaries =>
      (_$archivedSeasonSummariesComputed ??=
              Computed<List<PredictorSeasonSummary>>(
                () => super.archivedSeasonSummaries,
                name: 'PredictorScreenControllerBase.archivedSeasonSummaries',
              ))
          .value;

  late final _$racesAtom = Atom(
    name: 'PredictorScreenControllerBase.races',
    context: context,
  );

  @override
  AsyncValue<List<RacesModel>> get races {
    _$racesAtom.reportRead();
    return super.races;
  }

  @override
  set races(AsyncValue<List<RacesModel>> value) {
    _$racesAtom.reportWrite(value, super.races, () {
      super.races = value;
    });
  }

  late final _$driversAtom = Atom(
    name: 'PredictorScreenControllerBase.drivers',
    context: context,
  );

  @override
  AsyncValue<List<DriverModel>> get drivers {
    _$driversAtom.reportRead();
    return super.drivers;
  }

  @override
  set drivers(AsyncValue<List<DriverModel>> value) {
    _$driversAtom.reportWrite(value, super.drivers, () {
      super.drivers = value;
    });
  }

  late final _$storeAtom = Atom(
    name: 'PredictorScreenControllerBase.store',
    context: context,
  );

  @override
  PredictorStore get store {
    _$storeAtom.reportRead();
    return super.store;
  }

  @override
  set store(PredictorStore value) {
    _$storeAtom.reportWrite(value, super.store, () {
      super.store = value;
    });
  }

  late final _$nowAtom = Atom(
    name: 'PredictorScreenControllerBase.now',
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

  late final _$allDataIsLoadedAtom = Atom(
    name: 'PredictorScreenControllerBase.allDataIsLoaded',
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

  late final _$selectedGridAtom = Atom(
    name: 'PredictorScreenControllerBase.selectedGrid',
    context: context,
  );

  @override
  PredictorGridKind get selectedGrid {
    _$selectedGridAtom.reportRead();
    return super.selectedGrid;
  }

  @override
  set selectedGrid(PredictorGridKind value) {
    _$selectedGridAtom.reportWrite(value, super.selectedGrid, () {
      super.selectedGrid = value;
    });
  }

  late final _$draftQualifyingOrderAtom = Atom(
    name: 'PredictorScreenControllerBase.draftQualifyingOrder',
    context: context,
  );

  @override
  ObservableList<String> get draftQualifyingOrder {
    _$draftQualifyingOrderAtom.reportRead();
    return super.draftQualifyingOrder;
  }

  @override
  set draftQualifyingOrder(ObservableList<String> value) {
    _$draftQualifyingOrderAtom.reportWrite(
      value,
      super.draftQualifyingOrder,
      () {
        super.draftQualifyingOrder = value;
      },
    );
  }

  late final _$draftRaceOrderAtom = Atom(
    name: 'PredictorScreenControllerBase.draftRaceOrder',
    context: context,
  );

  @override
  ObservableList<String> get draftRaceOrder {
    _$draftRaceOrderAtom.reportRead();
    return super.draftRaceOrder;
  }

  @override
  set draftRaceOrder(ObservableList<String> value) {
    _$draftRaceOrderAtom.reportWrite(value, super.draftRaceOrder, () {
      super.draftRaceOrder = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    'PredictorScreenControllerBase.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$refreshAllAsyncAction = AsyncAction(
    'PredictorScreenControllerBase.refreshAll',
    context: context,
  );

  @override
  Future<void> refreshAll() {
    return _$refreshAllAsyncAction.run(() => super.refreshAll());
  }

  late final _$reorderDraftAsyncAction = AsyncAction(
    'PredictorScreenControllerBase.reorderDraft',
    context: context,
  );

  @override
  Future<void> reorderDraft({required int oldIndex, required int newIndex}) {
    return _$reorderDraftAsyncAction.run(
      () => super.reorderDraft(oldIndex: oldIndex, newIndex: newIndex),
    );
  }

  late final _$_ensureCurrentDraftAsyncAction = AsyncAction(
    'PredictorScreenControllerBase._ensureCurrentDraft',
    context: context,
  );

  @override
  Future<void> _ensureCurrentDraft() {
    return _$_ensureCurrentDraftAsyncAction.run(
      () => super._ensureCurrentDraft(),
    );
  }

  late final _$_scoreAllPendingAsyncAction = AsyncAction(
    'PredictorScreenControllerBase._scoreAllPending',
    context: context,
  );

  @override
  Future<void> _scoreAllPending() {
    return _$_scoreAllPendingAsyncAction.run(() => super._scoreAllPending());
  }

  late final _$_onBecameLockedAsyncAction = AsyncAction(
    'PredictorScreenControllerBase._onBecameLocked',
    context: context,
  );

  @override
  Future<void> _onBecameLocked(RacesModel race) {
    return _$_onBecameLockedAsyncAction.run(() => super._onBecameLocked(race));
  }

  late final _$_loadScheduleAsyncAction = AsyncAction(
    'PredictorScreenControllerBase._loadSchedule',
    context: context,
  );

  @override
  Future<void> _loadSchedule() {
    return _$_loadScheduleAsyncAction.run(() => super._loadSchedule());
  }

  late final _$_loadDriversListAsyncAction = AsyncAction(
    'PredictorScreenControllerBase._loadDriversList',
    context: context,
  );

  @override
  Future<void> _loadDriversList() {
    return _$_loadDriversListAsyncAction.run(() => super._loadDriversList());
  }

  late final _$PredictorScreenControllerBaseActionController = ActionController(
    name: 'PredictorScreenControllerBase',
    context: context,
  );

  @override
  void selectGrid(PredictorGridKind kind) {
    final _$actionInfo = _$PredictorScreenControllerBaseActionController
        .startAction(name: 'PredictorScreenControllerBase.selectGrid');
    try {
      return super.selectGrid(kind);
    } finally {
      _$PredictorScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _tickNow() {
    final _$actionInfo = _$PredictorScreenControllerBaseActionController
        .startAction(name: 'PredictorScreenControllerBase._tickNow');
    try {
      return super._tickNow();
    } finally {
      _$PredictorScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
races: ${races},
drivers: ${drivers},
store: ${store},
now: ${now},
allDataIsLoaded: ${allDataIsLoaded},
selectedGrid: ${selectedGrid},
draftQualifyingOrder: ${draftQualifyingOrder},
draftRaceOrder: ${draftRaceOrder},
screenError: ${screenError},
seasonYear: ${seasonYear},
seasonTotalPoints: ${seasonTotalPoints},
upcomingRace: ${upcomingRace},
lockAt: ${lockAt},
isLocked: ${isLocked},
missingQualifyingTime: ${missingQualifyingTime},
lockCountdown: ${lockCountdown},
currentPrediction: ${currentPrediction},
historyWeekends: ${historyWeekends},
archivedSeasonSummaries: ${archivedSeasonSummaries}
    ''';
  }
}
