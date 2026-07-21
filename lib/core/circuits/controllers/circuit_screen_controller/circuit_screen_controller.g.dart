// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circuit_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CircuitScreenController on CircuitScreenControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'CircuitScreenControllerBase.screenError',
      )).value;
  Computed<bool>? _$isLoadedComputed;

  @override
  bool get isLoaded => (_$isLoadedComputed ??= Computed<bool>(
    () => super.isLoaded,
    name: 'CircuitScreenControllerBase.isLoaded',
  )).value;
  Computed<bool>? _$isPhotoLoadingComputed;

  @override
  bool get isPhotoLoading => (_$isPhotoLoadingComputed ??= Computed<bool>(
    () => super.isPhotoLoading,
    name: 'CircuitScreenControllerBase.isPhotoLoading',
  )).value;
  Computed<String?>? _$circuitPhotoUrlComputed;

  @override
  String? get circuitPhotoUrl =>
      (_$circuitPhotoUrlComputed ??= Computed<String?>(
        () => super.circuitPhotoUrl,
        name: 'CircuitScreenControllerBase.circuitPhotoUrl',
      )).value;

  late final _$winnersAtom = Atom(
    name: 'CircuitScreenControllerBase.winners',
    context: context,
  );

  @override
  AsyncValue<List<CircuitRaceWin>> get winners {
    _$winnersAtom.reportRead();
    return super.winners;
  }

  @override
  set winners(AsyncValue<List<CircuitRaceWin>> value) {
    _$winnersAtom.reportWrite(value, super.winners, () {
      super.winners = value;
    });
  }

  late final _$photoUrlAtom = Atom(
    name: 'CircuitScreenControllerBase.photoUrl',
    context: context,
  );

  @override
  AsyncValue<String?> get photoUrl {
    _$photoUrlAtom.reportRead();
    return super.photoUrl;
  }

  @override
  set photoUrl(AsyncValue<String?> value) {
    _$photoUrlAtom.reportWrite(value, super.photoUrl, () {
      super.photoUrl = value;
    });
  }

  late final _$loadAllAsyncAction = AsyncAction(
    'CircuitScreenControllerBase.loadAll',
    context: context,
  );

  @override
  Future<void> loadAll() {
    return _$loadAllAsyncAction.run(() => super.loadAll());
  }

  late final _$loadWinnersAsyncAction = AsyncAction(
    'CircuitScreenControllerBase.loadWinners',
    context: context,
  );

  @override
  Future<void> loadWinners() {
    return _$loadWinnersAsyncAction.run(() => super.loadWinners());
  }

  late final _$loadPhotoAsyncAction = AsyncAction(
    'CircuitScreenControllerBase.loadPhoto',
    context: context,
  );

  @override
  Future<void> loadPhoto() {
    return _$loadPhotoAsyncAction.run(() => super.loadPhoto());
  }

  @override
  String toString() {
    return '''
winners: ${winners},
photoUrl: ${photoUrl},
screenError: ${screenError},
isLoaded: ${isLoaded},
isPhotoLoading: ${isPhotoLoading},
circuitPhotoUrl: ${circuitPhotoUrl}
    ''';
  }
}
