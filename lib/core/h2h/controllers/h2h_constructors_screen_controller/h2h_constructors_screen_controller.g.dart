// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'h2h_constructors_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$H2hConstructorsScreenController
    on H2hConstructorsScreenControllerBase, Store {
  Computed<bool>? _$isSeasonScopeComputed;

  @override
  bool get isSeasonScope => (_$isSeasonScopeComputed ??= Computed<bool>(
    () => super.isSeasonScope,
    name: 'H2hConstructorsScreenControllerBase.isSeasonScope',
  )).value;
  Computed<bool>? _$showYearPickerComputed;

  @override
  bool get showYearPicker => (_$showYearPickerComputed ??= Computed<bool>(
    () => super.showYearPicker,
    name: 'H2hConstructorsScreenControllerBase.showYearPicker',
  )).value;
  Computed<String?>? _$selectedSeasonComputed;

  @override
  String? get selectedSeason => (_$selectedSeasonComputed ??= Computed<String?>(
    () => super.selectedSeason,
    name: 'H2hConstructorsScreenControllerBase.selectedSeason',
  )).value;
  Computed<bool>? _$canCompareComputed;

  @override
  bool get canCompare => (_$canCompareComputed ??= Computed<bool>(
    () => super.canCompare,
    name: 'H2hConstructorsScreenControllerBase.canCompare',
  )).value;
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'H2hConstructorsScreenControllerBase.screenError',
      )).value;

  late final _$scopeModeAtom = Atom(
    name: 'H2hConstructorsScreenControllerBase.scopeMode',
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
    name: 'H2hConstructorsScreenControllerBase.useCurrentSeason',
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

  late final _$currentConstructorsOnlyAtom = Atom(
    name: 'H2hConstructorsScreenControllerBase.currentConstructorsOnly',
    context: context,
  );

  @override
  bool get currentConstructorsOnly {
    _$currentConstructorsOnlyAtom.reportRead();
    return super.currentConstructorsOnly;
  }

  @override
  set currentConstructorsOnly(bool value) {
    _$currentConstructorsOnlyAtom.reportWrite(
      value,
      super.currentConstructorsOnly,
      () {
        super.currentConstructorsOnly = value;
      },
    );
  }

  late final _$latestSeasonAtom = Atom(
    name: 'H2hConstructorsScreenControllerBase.latestSeason',
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
    name: 'H2hConstructorsScreenControllerBase.seasonSelected',
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

  late final _$constructorAAtom = Atom(
    name: 'H2hConstructorsScreenControllerBase.constructorA',
    context: context,
  );

  @override
  ConstructorModel? get constructorA {
    _$constructorAAtom.reportRead();
    return super.constructorA;
  }

  @override
  set constructorA(ConstructorModel? value) {
    _$constructorAAtom.reportWrite(value, super.constructorA, () {
      super.constructorA = value;
    });
  }

  late final _$constructorBAtom = Atom(
    name: 'H2hConstructorsScreenControllerBase.constructorB',
    context: context,
  );

  @override
  ConstructorModel? get constructorB {
    _$constructorBAtom.reportRead();
    return super.constructorB;
  }

  @override
  set constructorB(ConstructorModel? value) {
    _$constructorBAtom.reportWrite(value, super.constructorB, () {
      super.constructorB = value;
    });
  }

  late final _$comparisonAtom = Atom(
    name: 'H2hConstructorsScreenControllerBase.comparison',
    context: context,
  );

  @override
  AsyncValue<H2hConstructorsCompareResult?> get comparison {
    _$comparisonAtom.reportRead();
    return super.comparison;
  }

  @override
  set comparison(AsyncValue<H2hConstructorsCompareResult?> value) {
    _$comparisonAtom.reportWrite(value, super.comparison, () {
      super.comparison = value;
    });
  }

  late final _$bootstrapAsyncAction = AsyncAction(
    'H2hConstructorsScreenControllerBase.bootstrap',
    context: context,
  );

  @override
  Future<void> bootstrap() {
    return _$bootstrapAsyncAction.run(() => super.bootstrap());
  }

  late final _$compareAsyncAction = AsyncAction(
    'H2hConstructorsScreenControllerBase.compare',
    context: context,
  );

  @override
  Future<void> compare() {
    return _$compareAsyncAction.run(() => super.compare());
  }

  late final _$refreshComparisonAsyncAction = AsyncAction(
    'H2hConstructorsScreenControllerBase.refreshComparison',
    context: context,
  );

  @override
  Future<void> refreshComparison() {
    return _$refreshComparisonAsyncAction.run(() => super.refreshComparison());
  }

  late final _$H2hConstructorsScreenControllerBaseActionController =
      ActionController(
        name: 'H2hConstructorsScreenControllerBase',
        context: context,
      );

  @override
  void setScopeMode(int mode) {
    final _$actionInfo = _$H2hConstructorsScreenControllerBaseActionController
        .startAction(name: 'H2hConstructorsScreenControllerBase.setScopeMode');
    try {
      return super.setScopeMode(mode);
    } finally {
      _$H2hConstructorsScreenControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void setUseCurrentSeason(bool value) {
    final _$actionInfo = _$H2hConstructorsScreenControllerBaseActionController
        .startAction(
          name: 'H2hConstructorsScreenControllerBase.setUseCurrentSeason',
        );
    try {
      return super.setUseCurrentSeason(value);
    } finally {
      _$H2hConstructorsScreenControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void setCurrentConstructorsOnly(bool value) {
    final _$actionInfo = _$H2hConstructorsScreenControllerBaseActionController
        .startAction(
          name:
              'H2hConstructorsScreenControllerBase.setCurrentConstructorsOnly',
        );
    try {
      return super.setCurrentConstructorsOnly(value);
    } finally {
      _$H2hConstructorsScreenControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void onSeasonChanged() {
    final _$actionInfo = _$H2hConstructorsScreenControllerBaseActionController
        .startAction(
          name: 'H2hConstructorsScreenControllerBase.onSeasonChanged',
        );
    try {
      return super.onSeasonChanged();
    } finally {
      _$H2hConstructorsScreenControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void setConstructorA(ConstructorModel constructor) {
    final _$actionInfo = _$H2hConstructorsScreenControllerBaseActionController
        .startAction(
          name: 'H2hConstructorsScreenControllerBase.setConstructorA',
        );
    try {
      return super.setConstructorA(constructor);
    } finally {
      _$H2hConstructorsScreenControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void setConstructorB(ConstructorModel constructor) {
    final _$actionInfo = _$H2hConstructorsScreenControllerBaseActionController
        .startAction(
          name: 'H2hConstructorsScreenControllerBase.setConstructorB',
        );
    try {
      return super.setConstructorB(constructor);
    } finally {
      _$H2hConstructorsScreenControllerBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  String toString() {
    return '''
scopeMode: ${scopeMode},
useCurrentSeason: ${useCurrentSeason},
currentConstructorsOnly: ${currentConstructorsOnly},
latestSeason: ${latestSeason},
seasonSelected: ${seasonSelected},
constructorA: ${constructorA},
constructorB: ${constructorB},
comparison: ${comparison},
isSeasonScope: ${isSeasonScope},
showYearPicker: ${showYearPicker},
selectedSeason: ${selectedSeason},
canCompare: ${canCompare},
screenError: ${screenError}
    ''';
  }
}
