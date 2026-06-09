// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_map_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CustomMapController on CustomMapControllerBase, Store {
  late final _$streamedMapObjectsAtom = Atom(
    name: 'CustomMapControllerBase.streamedMapObjects',
    context: context,
  );

  @override
  ObservableList<MapObject<dynamic>> get streamedMapObjects {
    _$streamedMapObjectsAtom.reportRead();
    return super.streamedMapObjects;
  }

  @override
  set streamedMapObjects(ObservableList<MapObject<dynamic>> value) {
    _$streamedMapObjectsAtom.reportWrite(value, super.streamedMapObjects, () {
      super.streamedMapObjects = value;
    });
  }

  late final _$isDraggingAtom = Atom(
    name: 'CustomMapControllerBase.isDragging',
    context: context,
  );

  @override
  bool get isDragging {
    _$isDraggingAtom.reportRead();
    return super.isDragging;
  }

  @override
  set isDragging(bool value) {
    _$isDraggingAtom.reportWrite(value, super.isDragging, () {
      super.isDragging = value;
    });
  }

  late final _$initAsyncAction = AsyncAction(
    'CustomMapControllerBase.init',
    context: context,
  );

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$CustomMapControllerBaseActionController = ActionController(
    name: 'CustomMapControllerBase',
    context: context,
  );

  @override
  void changeIsDraggingState(bool value) {
    final _$actionInfo = _$CustomMapControllerBaseActionController.startAction(
      name: 'CustomMapControllerBase.changeIsDraggingState',
    );
    try {
      return super.changeIsDraggingState(value);
    } finally {
      _$CustomMapControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updatePoints(List<Point> newPoints) {
    final _$actionInfo = _$CustomMapControllerBaseActionController.startAction(
      name: 'CustomMapControllerBase.updatePoints',
    );
    try {
      return super.updatePoints(newPoints);
    } finally {
      _$CustomMapControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setStreamedMapObjects(List<MapObject<dynamic>> objects) {
    final _$actionInfo = _$CustomMapControllerBaseActionController.startAction(
      name: 'CustomMapControllerBase._setStreamedMapObjects',
    );
    try {
      return super._setStreamedMapObjects(objects);
    } finally {
      _$CustomMapControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
streamedMapObjects: ${streamedMapObjects},
isDragging: ${isDragging}
    ''';
  }
}
