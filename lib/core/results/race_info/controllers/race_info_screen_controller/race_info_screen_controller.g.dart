// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'race_info_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RaceInfoScreenController on RaceInfoScreenControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'RaceInfoScreenControllerBase.screenError',
      )).value;

  late final _$raceAppBarPinnedAtom = Atom(
    name: 'RaceInfoScreenControllerBase.raceAppBarPinned',
    context: context,
  );

  @override
  bool get raceAppBarPinned {
    _$raceAppBarPinnedAtom.reportRead();
    return super.raceAppBarPinned;
  }

  @override
  set raceAppBarPinned(bool value) {
    _$raceAppBarPinnedAtom.reportWrite(value, super.raceAppBarPinned, () {
      super.raceAppBarPinned = value;
    });
  }

  late final _$sprintAppBarPinnedAtom = Atom(
    name: 'RaceInfoScreenControllerBase.sprintAppBarPinned',
    context: context,
  );

  @override
  bool get sprintAppBarPinned {
    _$sprintAppBarPinnedAtom.reportRead();
    return super.sprintAppBarPinned;
  }

  @override
  set sprintAppBarPinned(bool value) {
    _$sprintAppBarPinnedAtom.reportWrite(value, super.sprintAppBarPinned, () {
      super.sprintAppBarPinned = value;
    });
  }

  late final _$qualificationAppBarPinnedAtom = Atom(
    name: 'RaceInfoScreenControllerBase.qualificationAppBarPinned',
    context: context,
  );

  @override
  bool get qualificationAppBarPinned {
    _$qualificationAppBarPinnedAtom.reportRead();
    return super.qualificationAppBarPinned;
  }

  @override
  set qualificationAppBarPinned(bool value) {
    _$qualificationAppBarPinnedAtom.reportWrite(
      value,
      super.qualificationAppBarPinned,
      () {
        super.qualificationAppBarPinned = value;
      },
    );
  }

  late final _$pitStopsAppBarPinnedAtom = Atom(
    name: 'RaceInfoScreenControllerBase.pitStopsAppBarPinned',
    context: context,
  );

  @override
  bool get pitStopsAppBarPinned {
    _$pitStopsAppBarPinnedAtom.reportRead();
    return super.pitStopsAppBarPinned;
  }

  @override
  set pitStopsAppBarPinned(bool value) {
    _$pitStopsAppBarPinnedAtom.reportWrite(
      value,
      super.pitStopsAppBarPinned,
      () {
        super.pitStopsAppBarPinned = value;
      },
    );
  }

  late final _$allDataIsLoadedAtom = Atom(
    name: 'RaceInfoScreenControllerBase.allDataIsLoaded',
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

  late final _$sprintResultsAtom = Atom(
    name: 'RaceInfoScreenControllerBase.sprintResults',
    context: context,
  );

  @override
  AsyncValue<List<ResultsModel>> get sprintResults {
    _$sprintResultsAtom.reportRead();
    return super.sprintResults;
  }

  @override
  set sprintResults(AsyncValue<List<ResultsModel>> value) {
    _$sprintResultsAtom.reportWrite(value, super.sprintResults, () {
      super.sprintResults = value;
    });
  }

  late final _$qualifyingResultsAtom = Atom(
    name: 'RaceInfoScreenControllerBase.qualifyingResults',
    context: context,
  );

  @override
  AsyncValue<List<QualifyingResultsModel>> get qualifyingResults {
    _$qualifyingResultsAtom.reportRead();
    return super.qualifyingResults;
  }

  @override
  set qualifyingResults(AsyncValue<List<QualifyingResultsModel>> value) {
    _$qualifyingResultsAtom.reportWrite(value, super.qualifyingResults, () {
      super.qualifyingResults = value;
    });
  }

  late final _$pitStopsAtom = Atom(
    name: 'RaceInfoScreenControllerBase.pitStops',
    context: context,
  );

  @override
  AsyncValue<List<PitStopsModel>> get pitStops {
    _$pitStopsAtom.reportRead();
    return super.pitStops;
  }

  @override
  set pitStops(AsyncValue<List<PitStopsModel>> value) {
    _$pitStopsAtom.reportWrite(value, super.pitStops, () {
      super.pitStops = value;
    });
  }

  late final _$loadAllDataAsyncAction = AsyncAction(
    'RaceInfoScreenControllerBase.loadAllData',
    context: context,
  );

  @override
  Future<void> loadAllData() {
    return _$loadAllDataAsyncAction.run(() => super.loadAllData());
  }

  late final _$loadSprintResultsAsyncAction = AsyncAction(
    'RaceInfoScreenControllerBase.loadSprintResults',
    context: context,
  );

  @override
  Future<void> loadSprintResults() {
    return _$loadSprintResultsAsyncAction.run(() => super.loadSprintResults());
  }

  late final _$loadQualifyingResultsAsyncAction = AsyncAction(
    'RaceInfoScreenControllerBase.loadQualifyingResults',
    context: context,
  );

  @override
  Future<void> loadQualifyingResults() {
    return _$loadQualifyingResultsAsyncAction.run(
      () => super.loadQualifyingResults(),
    );
  }

  late final _$loadPitStopsAsyncAction = AsyncAction(
    'RaceInfoScreenControllerBase.loadPitStops',
    context: context,
  );

  @override
  Future<void> loadPitStops() {
    return _$loadPitStopsAsyncAction.run(() => super.loadPitStops());
  }

  late final _$RaceInfoScreenControllerBaseActionController = ActionController(
    name: 'RaceInfoScreenControllerBase',
    context: context,
  );

  @override
  void onRaceTableVisibilityChanged(VisibilityInfo info) {
    final _$actionInfo = _$RaceInfoScreenControllerBaseActionController
        .startAction(
          name: 'RaceInfoScreenControllerBase.onRaceTableVisibilityChanged',
        );
    try {
      return super.onRaceTableVisibilityChanged(info);
    } finally {
      _$RaceInfoScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSprintTableVisibilityChanged(VisibilityInfo info) {
    final _$actionInfo = _$RaceInfoScreenControllerBaseActionController
        .startAction(
          name: 'RaceInfoScreenControllerBase.onSprintTableVisibilityChanged',
        );
    try {
      return super.onSprintTableVisibilityChanged(info);
    } finally {
      _$RaceInfoScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onQualificationTableVisibilityChanged(VisibilityInfo info) {
    final _$actionInfo = _$RaceInfoScreenControllerBaseActionController
        .startAction(
          name:
              'RaceInfoScreenControllerBase.onQualificationTableVisibilityChanged',
        );
    try {
      return super.onQualificationTableVisibilityChanged(info);
    } finally {
      _$RaceInfoScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onPitStopsTableVisibilityChanged(VisibilityInfo info) {
    final _$actionInfo = _$RaceInfoScreenControllerBaseActionController
        .startAction(
          name: 'RaceInfoScreenControllerBase.onPitStopsTableVisibilityChanged',
        );
    try {
      return super.onPitStopsTableVisibilityChanged(info);
    } finally {
      _$RaceInfoScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
raceAppBarPinned: ${raceAppBarPinned},
sprintAppBarPinned: ${sprintAppBarPinned},
qualificationAppBarPinned: ${qualificationAppBarPinned},
pitStopsAppBarPinned: ${pitStopsAppBarPinned},
allDataIsLoaded: ${allDataIsLoaded},
sprintResults: ${sprintResults},
qualifyingResults: ${qualifyingResults},
pitStops: ${pitStops},
screenError: ${screenError}
    ''';
  }
}
