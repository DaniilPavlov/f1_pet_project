// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeScreenController on HomeScreenControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'HomeScreenControllerBase.screenError',
      )).value;

  late final _$currentDriversAtom = Atom(
    name: 'HomeScreenControllerBase.currentDrivers',
    context: context,
  );

  @override
  AsyncValue<List<DriverStandingsModel>> get currentDrivers {
    _$currentDriversAtom.reportRead();
    return super.currentDrivers;
  }

  @override
  set currentDrivers(AsyncValue<List<DriverStandingsModel>> value) {
    _$currentDriversAtom.reportWrite(value, super.currentDrivers, () {
      super.currentDrivers = value;
    });
  }

  late final _$currentConstructorsAtom = Atom(
    name: 'HomeScreenControllerBase.currentConstructors',
    context: context,
  );

  @override
  AsyncValue<List<ConstructorStandingsModel>> get currentConstructors {
    _$currentConstructorsAtom.reportRead();
    return super.currentConstructors;
  }

  @override
  set currentConstructors(AsyncValue<List<ConstructorStandingsModel>> value) {
    _$currentConstructorsAtom.reportWrite(value, super.currentConstructors, () {
      super.currentConstructors = value;
    });
  }

  late final _$currentSeasonAtom = Atom(
    name: 'HomeScreenControllerBase.currentSeason',
    context: context,
  );

  @override
  String get currentSeason {
    _$currentSeasonAtom.reportRead();
    return super.currentSeason;
  }

  @override
  set currentSeason(String value) {
    _$currentSeasonAtom.reportWrite(value, super.currentSeason, () {
      super.currentSeason = value;
    });
  }

  late final _$currentRoundAtom = Atom(
    name: 'HomeScreenControllerBase.currentRound',
    context: context,
  );

  @override
  String get currentRound {
    _$currentRoundAtom.reportRead();
    return super.currentRound;
  }

  @override
  set currentRound(String value) {
    _$currentRoundAtom.reportWrite(value, super.currentRound, () {
      super.currentRound = value;
    });
  }

  late final _$loadAllDataAsyncAction = AsyncAction(
    'HomeScreenControllerBase.loadAllData',
    context: context,
  );

  @override
  Future<void> loadAllData() {
    return _$loadAllDataAsyncAction.run(() => super.loadAllData());
  }

  late final _$loadCurrentDriversStandingsAsyncAction = AsyncAction(
    'HomeScreenControllerBase.loadCurrentDriversStandings',
    context: context,
  );

  @override
  Future<void> loadCurrentDriversStandings() {
    return _$loadCurrentDriversStandingsAsyncAction.run(
      () => super.loadCurrentDriversStandings(),
    );
  }

  late final _$loadCurrentConstructorsStandingsAsyncAction = AsyncAction(
    'HomeScreenControllerBase.loadCurrentConstructorsStandings',
    context: context,
  );

  @override
  Future<void> loadCurrentConstructorsStandings() {
    return _$loadCurrentConstructorsStandingsAsyncAction.run(
      () => super.loadCurrentConstructorsStandings(),
    );
  }

  @override
  String toString() {
    return '''
currentDrivers: ${currentDrivers},
currentConstructors: ${currentConstructors},
currentSeason: ${currentSeason},
currentRound: ${currentRound},
screenError: ${screenError}
    ''';
  }
}
