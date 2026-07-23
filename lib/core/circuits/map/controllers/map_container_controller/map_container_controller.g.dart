// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_container_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MapContainerController on MapContainerControllerBase, Store {
  late final _$listPointsAtom = Atom(
    name: 'MapContainerControllerBase.listPoints',
    context: context,
  );

  @override
  ObservableList<ym.Point> get listPoints {
    _$listPointsAtom.reportRead();
    return super.listPoints;
  }

  @override
  set listPoints(ObservableList<ym.Point> value) {
    _$listPointsAtom.reportWrite(value, super.listPoints, () {
      super.listPoints = value;
    });
  }

  late final _$MapContainerControllerBaseActionController = ActionController(
    name: 'MapContainerControllerBase',
    context: context,
  );

  @override
  void init() {
    final _$actionInfo = _$MapContainerControllerBaseActionController
        .startAction(name: 'MapContainerControllerBase.init');
    try {
      return super.init();
    } finally {
      _$MapContainerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updatePoints(List<ym.Point> points) {
    final _$actionInfo = _$MapContainerControllerBaseActionController
        .startAction(name: 'MapContainerControllerBase.updatePoints');
    try {
      return super.updatePoints(points);
    } finally {
      _$MapContainerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listPoints: ${listPoints}
    ''';
  }
}
