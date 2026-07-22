// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circuits_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CircuitsScreenController on CircuitsScreenControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'CircuitsScreenControllerBase.screenError',
      )).value;

  late final _$circuitsAtom = Atom(
    name: 'CircuitsScreenControllerBase.circuits',
    context: context,
  );

  @override
  AsyncValue<List<CircuitModel>> get circuits {
    _$circuitsAtom.reportRead();
    return super.circuits;
  }

  @override
  set circuits(AsyncValue<List<CircuitModel>> value) {
    _$circuitsAtom.reportWrite(value, super.circuits, () {
      super.circuits = value;
    });
  }

  late final _$activePageAtom = Atom(
    name: 'CircuitsScreenControllerBase.activePage',
    context: context,
  );

  @override
  int get activePage {
    _$activePageAtom.reportRead();
    return super.activePage;
  }

  @override
  set activePage(int value) {
    _$activePageAtom.reportWrite(value, super.activePage, () {
      super.activePage = value;
    });
  }

  late final _$loadCircuitsAsyncAction = AsyncAction(
    'CircuitsScreenControllerBase.loadCircuits',
    context: context,
  );

  @override
  Future<void> loadCircuits() {
    return _$loadCircuitsAsyncAction.run(() => super.loadCircuits());
  }

  late final _$refreshAllAsyncAction = AsyncAction(
    'CircuitsScreenControllerBase.refreshAll',
    context: context,
  );

  @override
  Future<void> refreshAll() {
    return _$refreshAllAsyncAction.run(() => super.refreshAll());
  }

  late final _$CircuitsScreenControllerBaseActionController = ActionController(
    name: 'CircuitsScreenControllerBase',
    context: context,
  );

  @override
  void changeActivePage(int value) {
    final _$actionInfo = _$CircuitsScreenControllerBaseActionController
        .startAction(name: 'CircuitsScreenControllerBase.changeActivePage');
    try {
      return super.changeActivePage(value);
    } finally {
      _$CircuitsScreenControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
circuits: ${circuits},
activePage: ${activePage},
screenError: ${screenError}
    ''';
  }
}
