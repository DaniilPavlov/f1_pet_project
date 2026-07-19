// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'constructor_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConstructorScreenController on ConstructorScreenControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'ConstructorScreenControllerBase.screenError',
      )).value;
  Computed<bool>? _$isLoadedComputed;

  @override
  bool get isLoaded => (_$isLoadedComputed ??= Computed<bool>(
    () => super.isLoaded,
    name: 'ConstructorScreenControllerBase.isLoaded',
  )).value;

  late final _$careerStatsAtom = Atom(
    name: 'ConstructorScreenControllerBase.careerStats',
    context: context,
  );

  @override
  AsyncValue<CareerStats<DriverModel>> get careerStats {
    _$careerStatsAtom.reportRead();
    return super.careerStats;
  }

  @override
  set careerStats(AsyncValue<CareerStats<DriverModel>> value) {
    _$careerStatsAtom.reportWrite(value, super.careerStats, () {
      super.careerStats = value;
    });
  }

  late final _$loadCareerStatsAsyncAction = AsyncAction(
    'ConstructorScreenControllerBase.loadCareerStats',
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
