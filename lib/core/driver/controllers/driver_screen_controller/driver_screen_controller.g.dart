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
  Computed<EspnDriverCardData>? _$espnCardDataComputed;

  @override
  EspnDriverCardData get espnCardData =>
      (_$espnCardDataComputed ??= Computed<EspnDriverCardData>(
        () => super.espnCardData,
        name: 'DriverScreenControllerBase.espnCardData',
      )).value;
  Computed<bool>? _$isEspnLoadingComputed;

  @override
  bool get isEspnLoading => (_$isEspnLoadingComputed ??= Computed<bool>(
    () => super.isEspnLoading,
    name: 'DriverScreenControllerBase.isEspnLoading',
  )).value;

  late final _$careerStatsAtom = Atom(
    name: 'DriverScreenControllerBase.careerStats',
    context: context,
  );

  @override
  AsyncValue<CareerStats<ConstructorModel>> get careerStats {
    _$careerStatsAtom.reportRead();
    return super.careerStats;
  }

  @override
  set careerStats(AsyncValue<CareerStats<ConstructorModel>> value) {
    _$careerStatsAtom.reportWrite(value, super.careerStats, () {
      super.careerStats = value;
    });
  }

  late final _$espnCardAtom = Atom(
    name: 'DriverScreenControllerBase.espnCard',
    context: context,
  );

  @override
  AsyncValue<EspnDriverCardData> get espnCard {
    _$espnCardAtom.reportRead();
    return super.espnCard;
  }

  @override
  set espnCard(AsyncValue<EspnDriverCardData> value) {
    _$espnCardAtom.reportWrite(value, super.espnCard, () {
      super.espnCard = value;
    });
  }

  late final _$loadAllAsyncAction = AsyncAction(
    'DriverScreenControllerBase.loadAll',
    context: context,
  );

  @override
  Future<void> loadAll() {
    return _$loadAllAsyncAction.run(() => super.loadAll());
  }

  late final _$loadCareerStatsAsyncAction = AsyncAction(
    'DriverScreenControllerBase.loadCareerStats',
    context: context,
  );

  @override
  Future<void> loadCareerStats() {
    return _$loadCareerStatsAsyncAction.run(() => super.loadCareerStats());
  }

  late final _$loadEspnCardAsyncAction = AsyncAction(
    'DriverScreenControllerBase.loadEspnCard',
    context: context,
  );

  @override
  Future<void> loadEspnCard() {
    return _$loadEspnCardAsyncAction.run(() => super.loadEspnCard());
  }

  @override
  String toString() {
    return '''
careerStats: ${careerStats},
espnCard: ${espnCard},
screenError: ${screenError},
isLoaded: ${isLoaded},
espnCardData: ${espnCardData},
isEspnLoading: ${isEspnLoading}
    ''';
  }
}
