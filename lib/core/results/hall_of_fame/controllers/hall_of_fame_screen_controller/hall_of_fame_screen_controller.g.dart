// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall_of_fame_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HallOfFameScreenController on HallOfFameScreenControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'HallOfFameScreenControllerBase.screenError',
      )).value;

  late final _$driversStandingsAtom = Atom(
    name: 'HallOfFameScreenControllerBase.driversStandings',
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
    name: 'HallOfFameScreenControllerBase.constructorsStandings',
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

  late final _$fieldsInputtedAtom = Atom(
    name: 'HallOfFameScreenControllerBase.fieldsInputted',
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

  late final _$bootstrapAsyncAction = AsyncAction(
    'HallOfFameScreenControllerBase.bootstrap',
    context: context,
  );

  @override
  Future<void> bootstrap() {
    return _$bootstrapAsyncAction.run(() => super.bootstrap());
  }

  late final _$loadAllDataAsyncAction = AsyncAction(
    'HallOfFameScreenControllerBase.loadAllData',
    context: context,
  );

  @override
  Future<void> loadAllData() {
    return _$loadAllDataAsyncAction.run(() => super.loadAllData());
  }

  late final _$refreshAllAsyncAction = AsyncAction(
    'HallOfFameScreenControllerBase.refreshAll',
    context: context,
  );

  @override
  Future<void> refreshAll() {
    return _$refreshAllAsyncAction.run(() => super.refreshAll());
  }

  late final _$loadDriversStandingsAsyncAction = AsyncAction(
    'HallOfFameScreenControllerBase.loadDriversStandings',
    context: context,
  );

  @override
  Future<void> loadDriversStandings({required String year}) {
    return _$loadDriversStandingsAsyncAction.run(
      () => super.loadDriversStandings(year: year),
    );
  }

  late final _$loadConstructorsStandingsAsyncAction = AsyncAction(
    'HallOfFameScreenControllerBase.loadConstructorsStandings',
    context: context,
  );

  @override
  Future<void> loadConstructorsStandings({required String year}) {
    return _$loadConstructorsStandingsAsyncAction.run(
      () => super.loadConstructorsStandings(year: year),
    );
  }

  late final _$HallOfFameScreenControllerBaseActionController =
      ActionController(
        name: 'HallOfFameScreenControllerBase',
        context: context,
      );

  @override
  void checkFields() {
    final _$actionInfo = _$HallOfFameScreenControllerBaseActionController
        .startAction(name: 'HallOfFameScreenControllerBase.checkFields');
    try {
      return super.checkFields();
    } finally {
      _$HallOfFameScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
driversStandings: ${driversStandings},
constructorsStandings: ${constructorsStandings},
fieldsInputted: ${fieldsInputted},
screenError: ${screenError}
    ''';
  }
}
