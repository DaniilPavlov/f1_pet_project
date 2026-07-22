// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finish_status_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FinishStatusScreenController
    on FinishStatusScreenControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'FinishStatusScreenControllerBase.screenError',
      )).value;
  Computed<bool>? _$isLoadedComputed;

  @override
  bool get isLoaded => (_$isLoadedComputed ??= Computed<bool>(
    () => super.isLoaded,
    name: 'FinishStatusScreenControllerBase.isLoaded',
  )).value;

  late final _$statusesAtom = Atom(
    name: 'FinishStatusScreenControllerBase.statuses',
    context: context,
  );

  @override
  AsyncValue<List<FinishStatusItem>> get statuses {
    _$statusesAtom.reportRead();
    return super.statuses;
  }

  @override
  set statuses(AsyncValue<List<FinishStatusItem>> value) {
    _$statusesAtom.reportWrite(value, super.statuses, () {
      super.statuses = value;
    });
  }

  late final _$bootstrapAsyncAction = AsyncAction(
    'FinishStatusScreenControllerBase.bootstrap',
    context: context,
  );

  @override
  Future<void> bootstrap() {
    return _$bootstrapAsyncAction.run(() => super.bootstrap());
  }

  late final _$loadAllDataAsyncAction = AsyncAction(
    'FinishStatusScreenControllerBase.loadAllData',
    context: context,
  );

  @override
  Future<void> loadAllData() {
    return _$loadAllDataAsyncAction.run(() => super.loadAllData());
  }

  late final _$refreshAllAsyncAction = AsyncAction(
    'FinishStatusScreenControllerBase.refreshAll',
    context: context,
  );

  @override
  Future<void> refreshAll() {
    return _$refreshAllAsyncAction.run(() => super.refreshAll());
  }

  @override
  String toString() {
    return '''
statuses: ${statuses},
screenError: ${screenError},
isLoaded: ${isLoaded}
    ''';
  }
}
