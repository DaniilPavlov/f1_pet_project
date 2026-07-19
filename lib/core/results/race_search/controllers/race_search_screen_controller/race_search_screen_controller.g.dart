// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'race_search_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RaceSearchScreenController on RaceSearchScreenControllerBase, Store {
  late final _$searchedRaceAtom = Atom(
    name: 'RaceSearchScreenControllerBase.searchedRace',
    context: context,
  );

  @override
  AsyncValue<RacesModel?> get searchedRace {
    _$searchedRaceAtom.reportRead();
    return super.searchedRace;
  }

  @override
  set searchedRace(AsyncValue<RacesModel?> value) {
    _$searchedRaceAtom.reportWrite(value, super.searchedRace, () {
      super.searchedRace = value;
    });
  }

  late final _$dataIsLoadedAtom = Atom(
    name: 'RaceSearchScreenControllerBase.dataIsLoaded',
    context: context,
  );

  @override
  bool get dataIsLoaded {
    _$dataIsLoadedAtom.reportRead();
    return super.dataIsLoaded;
  }

  @override
  set dataIsLoaded(bool value) {
    _$dataIsLoadedAtom.reportWrite(value, super.dataIsLoaded, () {
      super.dataIsLoaded = value;
    });
  }

  late final _$fieldsInputtedAtom = Atom(
    name: 'RaceSearchScreenControllerBase.fieldsInputted',
    context: context,
  );

  @override
  bool get fieldsInputted {
    _$fieldsInputtedAtom.reportRead();
    return super.fieldsInputted;
  }

  @override
  set fieldsInputted(bool value) {
    _$fieldsInputtedAtom.reportWrite(value, super.fieldsInputted, () {
      super.fieldsInputted = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: 'RaceSearchScreenControllerBase.errorMessage',
    context: context,
  );

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$selectedSeasonAtom = Atom(
    name: 'RaceSearchScreenControllerBase.selectedSeason',
    context: context,
  );

  @override
  String get selectedSeason {
    _$selectedSeasonAtom.reportRead();
    return super.selectedSeason;
  }

  @override
  set selectedSeason(String value) {
    _$selectedSeasonAtom.reportWrite(value, super.selectedSeason, () {
      super.selectedSeason = value;
    });
  }

  late final _$loadRaceResultsAsyncAction = AsyncAction(
    'RaceSearchScreenControllerBase.loadRaceResults',
    context: context,
  );

  @override
  Future<void> loadRaceResults() {
    return _$loadRaceResultsAsyncAction.run(() => super.loadRaceResults());
  }

  late final _$RaceSearchScreenControllerBaseActionController =
      ActionController(
        name: 'RaceSearchScreenControllerBase',
        context: context,
      );

  @override
  void checkFields() {
    final _$actionInfo = _$RaceSearchScreenControllerBaseActionController
        .startAction(name: 'RaceSearchScreenControllerBase.checkFields');
    try {
      return super.checkFields();
    } finally {
      _$RaceSearchScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSeasonSelected() {
    final _$actionInfo = _$RaceSearchScreenControllerBaseActionController
        .startAction(name: 'RaceSearchScreenControllerBase.onSeasonSelected');
    try {
      return super.onSeasonSelected();
    } finally {
      _$RaceSearchScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onRacePicked(RacePick pick) {
    final _$actionInfo = _$RaceSearchScreenControllerBaseActionController
        .startAction(name: 'RaceSearchScreenControllerBase.onRacePicked');
    try {
      return super.onRacePicked(pick);
    } finally {
      _$RaceSearchScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchedRace: ${searchedRace},
dataIsLoaded: ${dataIsLoaded},
fieldsInputted: ${fieldsInputted},
errorMessage: ${errorMessage},
selectedSeason: ${selectedSeason}
    ''';
  }
}
