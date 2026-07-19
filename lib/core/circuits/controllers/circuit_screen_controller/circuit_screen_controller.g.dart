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

  late final _$loadWinnersAsyncAction = AsyncAction(
    'CircuitScreenControllerBase.loadWinners',
    context: context,
  );

  @override
  Future<void> loadWinners() {
    return _$loadWinnersAsyncAction.run(() => super.loadWinners());
  }

  @override
  String toString() {
    return '''
winners: ${winners},
screenError: ${screenError},
isLoaded: ${isLoaded}
    ''';
  }
}
