// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_rewind_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SeasonRewindScreenController
    on SeasonRewindScreenControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'SeasonRewindScreenControllerBase.screenError',
      )).value;
  Computed<RacesModel?>? _$selectedRaceComputed;

  @override
  RacesModel? get selectedRace =>
      (_$selectedRaceComputed ??= Computed<RacesModel?>(
        () => super.selectedRace,
        name: 'SeasonRewindScreenControllerBase.selectedRace',
      )).value;
  Computed<bool>? _$canPlayComputed;

  @override
  bool get canPlay => (_$canPlayComputed ??= Computed<bool>(
    () => super.canPlay,
    name: 'SeasonRewindScreenControllerBase.canPlay',
  )).value;
  Computed<bool>? _$hasChartDataComputed;

  @override
  bool get hasChartData => (_$hasChartDataComputed ??= Computed<bool>(
    () => super.hasChartData,
    name: 'SeasonRewindScreenControllerBase.hasChartData',
  )).value;
  Computed<bool>? _$isChartStaleComputed;

  @override
  bool get isChartStale => (_$isChartStaleComputed ??= Computed<bool>(
    () => super.isChartStale,
    name: 'SeasonRewindScreenControllerBase.isChartStale',
  )).value;

  late final _$racesAtom = Atom(
    name: 'SeasonRewindScreenControllerBase.races',
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

  late final _$driversStandingsAtom = Atom(
    name: 'SeasonRewindScreenControllerBase.driversStandings',
    context: context,
  );

  @override
  AsyncValue<List<StandingsListsModel>> get driversStandings {
    _$driversStandingsAtom.reportRead();
    return super.driversStandings;
  }

  @override
  set driversStandings(AsyncValue<List<StandingsListsModel>> value) {
    _$driversStandingsAtom.reportWrite(value, super.driversStandings, () {
      super.driversStandings = value;
    });
  }

  late final _$constructorsStandingsAtom = Atom(
    name: 'SeasonRewindScreenControllerBase.constructorsStandings',
    context: context,
  );

  @override
  AsyncValue<List<StandingsListsModel>> get constructorsStandings {
    _$constructorsStandingsAtom.reportRead();
    return super.constructorsStandings;
  }

  @override
  set constructorsStandings(AsyncValue<List<StandingsListsModel>> value) {
    _$constructorsStandingsAtom.reportWrite(
      value,
      super.constructorsStandings,
      () {
        super.constructorsStandings = value;
      },
    );
  }

  late final _$selectedRoundIndexAtom = Atom(
    name: 'SeasonRewindScreenControllerBase.selectedRoundIndex',
    context: context,
  );

  @override
  int get selectedRoundIndex {
    _$selectedRoundIndexAtom.reportRead();
    return super.selectedRoundIndex;
  }

  @override
  set selectedRoundIndex(int value) {
    _$selectedRoundIndexAtom.reportWrite(value, super.selectedRoundIndex, () {
      super.selectedRoundIndex = value;
    });
  }

  late final _$isPlayingAtom = Atom(
    name: 'SeasonRewindScreenControllerBase.isPlaying',
    context: context,
  );

  @override
  bool get isPlaying {
    _$isPlayingAtom.reportRead();
    return super.isPlaying;
  }

  @override
  set isPlaying(bool value) {
    _$isPlayingAtom.reportWrite(value, super.isPlaying, () {
      super.isPlaying = value;
    });
  }

  late final _$chartDriversAtom = Atom(
    name: 'SeasonRewindScreenControllerBase.chartDrivers',
    context: context,
  );

  @override
  List<DriverStandingsModel> get chartDrivers {
    _$chartDriversAtom.reportRead();
    return super.chartDrivers;
  }

  @override
  set chartDrivers(List<DriverStandingsModel> value) {
    _$chartDriversAtom.reportWrite(value, super.chartDrivers, () {
      super.chartDrivers = value;
    });
  }

  late final _$chartConstructorsAtom = Atom(
    name: 'SeasonRewindScreenControllerBase.chartConstructors',
    context: context,
  );

  @override
  List<ConstructorStandingsModel> get chartConstructors {
    _$chartConstructorsAtom.reportRead();
    return super.chartConstructors;
  }

  @override
  set chartConstructors(List<ConstructorStandingsModel> value) {
    _$chartConstructorsAtom.reportWrite(value, super.chartConstructors, () {
      super.chartConstructors = value;
    });
  }

  late final _$chartRoundAtom = Atom(
    name: 'SeasonRewindScreenControllerBase.chartRound',
    context: context,
  );

  @override
  String? get chartRound {
    _$chartRoundAtom.reportRead();
    return super.chartRound;
  }

  @override
  set chartRound(String? value) {
    _$chartRoundAtom.reportWrite(value, super.chartRound, () {
      super.chartRound = value;
    });
  }

  late final _$chartLoadingAtom = Atom(
    name: 'SeasonRewindScreenControllerBase.chartLoading',
    context: context,
  );

  @override
  bool get chartLoading {
    _$chartLoadingAtom.reportRead();
    return super.chartLoading;
  }

  @override
  set chartLoading(bool value) {
    _$chartLoadingAtom.reportWrite(value, super.chartLoading, () {
      super.chartLoading = value;
    });
  }

  late final _$bootstrapAsyncAction = AsyncAction(
    'SeasonRewindScreenControllerBase.bootstrap',
    context: context,
  );

  @override
  Future<void> bootstrap() {
    return _$bootstrapAsyncAction.run(() => super.bootstrap());
  }

  late final _$onSeasonChangedAsyncAction = AsyncAction(
    'SeasonRewindScreenControllerBase.onSeasonChanged',
    context: context,
  );

  @override
  Future<void> onSeasonChanged() {
    return _$onSeasonChangedAsyncAction.run(() => super.onSeasonChanged());
  }

  late final _$refreshAllAsyncAction = AsyncAction(
    'SeasonRewindScreenControllerBase.refreshAll',
    context: context,
  );

  @override
  Future<void> refreshAll() {
    return _$refreshAllAsyncAction.run(() => super.refreshAll());
  }

  late final _$loadSeasonAsyncAction = AsyncAction(
    'SeasonRewindScreenControllerBase.loadSeason',
    context: context,
  );

  @override
  Future<void> loadSeason() {
    return _$loadSeasonAsyncAction.run(() => super.loadSeason());
  }

  late final _$selectRoundAsyncAction = AsyncAction(
    'SeasonRewindScreenControllerBase.selectRound',
    context: context,
  );

  @override
  Future<void> selectRound(int index) {
    return _$selectRoundAsyncAction.run(() => super.selectRound(index));
  }

  late final _$loadStandingsForSelectedRoundAsyncAction = AsyncAction(
    'SeasonRewindScreenControllerBase.loadStandingsForSelectedRound',
    context: context,
  );

  @override
  Future<void> loadStandingsForSelectedRound() {
    return _$loadStandingsForSelectedRoundAsyncAction.run(
      () => super.loadStandingsForSelectedRound(),
    );
  }

  late final _$SeasonRewindScreenControllerBaseActionController =
      ActionController(
        name: 'SeasonRewindScreenControllerBase',
        context: context,
      );

  @override
  void previewRound(int index) {
    final _$actionInfo = _$SeasonRewindScreenControllerBaseActionController
        .startAction(name: 'SeasonRewindScreenControllerBase.previewRound');
    try {
      return super.previewRound(index);
    } finally {
      _$SeasonRewindScreenControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void togglePlayback() {
    final _$actionInfo = _$SeasonRewindScreenControllerBaseActionController
        .startAction(name: 'SeasonRewindScreenControllerBase.togglePlayback');
    try {
      return super.togglePlayback();
    } finally {
      _$SeasonRewindScreenControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void startPlayback() {
    final _$actionInfo = _$SeasonRewindScreenControllerBaseActionController
        .startAction(name: 'SeasonRewindScreenControllerBase.startPlayback');
    try {
      return super.startPlayback();
    } finally {
      _$SeasonRewindScreenControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void stopPlayback() {
    final _$actionInfo = _$SeasonRewindScreenControllerBaseActionController
        .startAction(name: 'SeasonRewindScreenControllerBase.stopPlayback');
    try {
      return super.stopPlayback();
    } finally {
      _$SeasonRewindScreenControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  String toString() {
    return '''
races: ${races},
driversStandings: ${driversStandings},
constructorsStandings: ${constructorsStandings},
selectedRoundIndex: ${selectedRoundIndex},
isPlaying: ${isPlaying},
chartDrivers: ${chartDrivers},
chartConstructors: ${chartConstructors},
chartRound: ${chartRound},
chartLoading: ${chartLoading},
screenError: ${screenError},
selectedRace: ${selectedRace},
canPlay: ${canPlay},
hasChartData: ${hasChartData},
isChartStale: ${isChartStale}
    ''';
  }
}
