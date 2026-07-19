// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DriverScreenController on DriverScreenControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'DriverScreenControllerBase.screenError',
      )).value;
  Computed<bool>? _$isLoadedComputed;

  @override
  bool get isLoaded => (_$isLoadedComputed ??= Computed<bool>(
    () => super.isLoaded,
    name: 'DriverScreenControllerBase.isLoaded',
  )).value;

  late final _$careerStatsAtom = Atom(
    name: 'DriverScreenControllerBase.careerStats',
    context: context,
  );

  @override
  AsyncValue<DriverCareerStats> get careerStats {
    _$careerStatsAtom.reportRead();
    return super.careerStats;
  }

  @override
  set careerStats(AsyncValue<DriverCareerStats> value) {
    _$careerStatsAtom.reportWrite(value, super.careerStats, () {
      super.careerStats = value;
    });
  }

  late final _$loadCareerStatsAsyncAction = AsyncAction(
    'DriverScreenControllerBase.loadCareerStats',
    context: context,
  );

  @override
  Future<void> loadCareerStats() {
    return _$loadCareerStatsAsyncAction.run(() => super.loadCareerStats());
  }

  @override
  String toString() {
    return '''
careerStats: ${careerStats},
screenError: ${screenError},
isLoaded: ${isLoaded}
    ''';
  }
}
