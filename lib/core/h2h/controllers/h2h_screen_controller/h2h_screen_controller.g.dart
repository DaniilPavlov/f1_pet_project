// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'h2h_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$H2hScreenController on H2hScreenControllerBase, Store {
  Computed<bool>? _$isSeasonScopeComputed;

  @override
  bool get isSeasonScope => (_$isSeasonScopeComputed ??= Computed<bool>(
    () => super.isSeasonScope,
    name: 'H2hScreenControllerBase.isSeasonScope',
  )).value;
  Computed<bool>? _$showYearPickerComputed;

  @override
  bool get showYearPicker => (_$showYearPickerComputed ??= Computed<bool>(
    () => super.showYearPicker,
    name: 'H2hScreenControllerBase.showYearPicker',
  )).value;
  Computed<String?>? _$selectedSeasonComputed;

  @override
  String? get selectedSeason => (_$selectedSeasonComputed ??= Computed<String?>(
    () => super.selectedSeason,
    name: 'H2hScreenControllerBase.selectedSeason',
  )).value;
  Computed<bool>? _$canCompareComputed;

  @override
  bool get canCompare => (_$canCompareComputed ??= Computed<bool>(
    () => super.canCompare,
    name: 'H2hScreenControllerBase.canCompare',
  )).value;
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'H2hScreenControllerBase.screenError',
      )).value;

  late final _$scopeModeAtom = Atom(
    name: 'H2hScreenControllerBase.scopeMode',
    context: context,
  );

  @override
  int get scopeMode {
    _$scopeModeAtom.reportRead();
    return super.scopeMode;
  }

  @override
  set scopeMode(int value) {
    _$scopeModeAtom.reportWrite(value, super.scopeMode, () {
      super.scopeMode = value;
    });
  }

  late final _$useCurrentSeasonAtom = Atom(
    name: 'H2hScreenControllerBase.useCurrentSeason',
    context: context,
  );

  @override
  bool get useCurrentSeason {
    _$useCurrentSeasonAtom.reportRead();
    return super.useCurrentSeason;
  }

  @override
  set useCurrentSeason(bool value) {
    _$useCurrentSeasonAtom.reportWrite(value, super.useCurrentSeason, () {
      super.useCurrentSeason = value;
    });
  }

  late final _$currentDriversOnlyAtom = Atom(
    name: 'H2hScreenControllerBase.currentDriversOnly',
    context: context,
  );

  @override
  bool get currentDriversOnly {
    _$currentDriversOnlyAtom.reportRead();
    return super.currentDriversOnly;
  }

  @override
  set currentDriversOnly(bool value) {
    _$currentDriversOnlyAtom.reportWrite(value, super.currentDriversOnly, () {
      super.currentDriversOnly = value;
    });
  }

  late final _$latestSeasonAtom = Atom(
    name: 'H2hScreenControllerBase.latestSeason',
    context: context,
  );

  @override
  String get latestSeason {
    _$latestSeasonAtom.reportRead();
    return super.latestSeason;
  }

  @override
  set latestSeason(String value) {
    _$latestSeasonAtom.reportWrite(value, super.latestSeason, () {
      super.latestSeason = value;
    });
  }

  late final _$seasonSelectedAtom = Atom(
    name: 'H2hScreenControllerBase.seasonSelected',
    context: context,
  );

  @override
  bool get seasonSelected {
    _$seasonSelectedAtom.reportRead();
    return super.seasonSelected;
  }

  @override
  set seasonSelected(bool value) {
    _$seasonSelectedAtom.reportWrite(value, super.seasonSelected, () {
      super.seasonSelected = value;
    });
  }

  late final _$driverAAtom = Atom(
    name: 'H2hScreenControllerBase.driverA',
    context: context,
  );

  @override
  DriverModel? get driverA {
    _$driverAAtom.reportRead();
    return super.driverA;
  }

  @override
  set driverA(DriverModel? value) {
    _$driverAAtom.reportWrite(value, super.driverA, () {
      super.driverA = value;
    });
  }

  late final _$driverBAtom = Atom(
    name: 'H2hScreenControllerBase.driverB',
    context: context,
  );

  @override
  DriverModel? get driverB {
    _$driverBAtom.reportRead();
    return super.driverB;
  }

  @override
  set driverB(DriverModel? value) {
    _$driverBAtom.reportWrite(value, super.driverB, () {
      super.driverB = value;
    });
  }

  late final _$comparisonAtom = Atom(
    name: 'H2hScreenControllerBase.comparison',
    context: context,
  );

  @override
  AsyncValue<H2hCompareResult?> get comparison {
    _$comparisonAtom.reportRead();
    return super.comparison;
  }

  @override
  set comparison(AsyncValue<H2hCompareResult?> value) {
    _$comparisonAtom.reportWrite(value, super.comparison, () {
      super.comparison = value;
    });
  }

  late final _$bootstrapAsyncAction = AsyncAction(
    'H2hScreenControllerBase.bootstrap',
    context: context,
  );

  @override
  Future<void> bootstrap() {
    return _$bootstrapAsyncAction.run(() => super.bootstrap());
  }

  late final _$compareAsyncAction = AsyncAction(
    'H2hScreenControllerBase.compare',
    context: context,
  );

  @override
  Future<void> compare() {
    return _$compareAsyncAction.run(() => super.compare());
  }

  late final _$refreshComparisonAsyncAction = AsyncAction(
    'H2hScreenControllerBase.refreshComparison',
    context: context,
  );

  @override
  Future<void> refreshComparison() {
    return _$refreshComparisonAsyncAction.run(() => super.refreshComparison());
  }

  late final _$H2hScreenControllerBaseActionController = ActionController(
    name: 'H2hScreenControllerBase',
    context: context,
  );

  @override
  void setScopeMode(int mode) {
    final _$actionInfo = _$H2hScreenControllerBaseActionController.startAction(
      name: 'H2hScreenControllerBase.setScopeMode',
    );
    try {
      return super.setScopeMode(mode);
    } finally {
      _$H2hScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUseCurrentSeason(bool value) {
    final _$actionInfo = _$H2hScreenControllerBaseActionController.startAction(
      name: 'H2hScreenControllerBase.setUseCurrentSeason',
    );
    try {
      return super.setUseCurrentSeason(value);
    } finally {
      _$H2hScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentDriversOnly(bool value) {
    final _$actionInfo = _$H2hScreenControllerBaseActionController.startAction(
      name: 'H2hScreenControllerBase.setCurrentDriversOnly',
    );
    try {
      return super.setCurrentDriversOnly(value);
    } finally {
      _$H2hScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSeasonChanged() {
    final _$actionInfo = _$H2hScreenControllerBaseActionController.startAction(
      name: 'H2hScreenControllerBase.onSeasonChanged',
    );
    try {
      return super.onSeasonChanged();
    } finally {
      _$H2hScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDriverA(DriverModel driver) {
    final _$actionInfo = _$H2hScreenControllerBaseActionController.startAction(
      name: 'H2hScreenControllerBase.setDriverA',
    );
    try {
      return super.setDriverA(driver);
    } finally {
      _$H2hScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDriverB(DriverModel driver) {
    final _$actionInfo = _$H2hScreenControllerBaseActionController.startAction(
      name: 'H2hScreenControllerBase.setDriverB',
    );
    try {
      return super.setDriverB(driver);
    } finally {
      _$H2hScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
scopeMode: ${scopeMode},
useCurrentSeason: ${useCurrentSeason},
currentDriversOnly: ${currentDriversOnly},
latestSeason: ${latestSeason},
seasonSelected: ${seasonSelected},
driverA: ${driverA},
driverB: ${driverB},
comparison: ${comparison},
isSeasonScope: ${isSeasonScope},
showYearPicker: ${showYearPicker},
selectedSeason: ${selectedSeason},
canCompare: ${canCompare},
screenError: ${screenError}
    ''';
  }
}
