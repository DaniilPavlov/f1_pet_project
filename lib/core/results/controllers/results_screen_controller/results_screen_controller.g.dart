// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'results_screen_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ResultsScreenController on ResultsScreenControllerBase, Store {
  Computed<CustomException?>? _$screenErrorComputed;

  @override
  CustomException? get screenError =>
      (_$screenErrorComputed ??= Computed<CustomException?>(
        () => super.screenError,
        name: 'ResultsScreenControllerBase.screenError',
      )).value;

  late final _$lastRaceAtom = Atom(
    name: 'ResultsScreenControllerBase.lastRace',
    context: context,
  );

  @override
  AsyncValue<RacesModel> get lastRace {
    _$lastRaceAtom.reportRead();
    return super.lastRace;
  }

  @override
  set lastRace(AsyncValue<RacesModel> value) {
    _$lastRaceAtom.reportWrite(value, super.lastRace, () {
      super.lastRace = value;
    });
  }

  late final _$showingCachedDataAtom = Atom(
    name: 'ResultsScreenControllerBase.showingCachedData',
    context: context,
  );

  @override
  bool get showingCachedData {
    _$showingCachedDataAtom.reportRead();
    return super.showingCachedData;
  }

  @override
  set showingCachedData(bool value) {
    _$showingCachedDataAtom.reportWrite(value, super.showingCachedData, () {
      super.showingCachedData = value;
    });
  }

  late final _$loadAllDataAsyncAction = AsyncAction(
    'ResultsScreenControllerBase.loadAllData',
    context: context,
  );

  @override
  Future<void> loadAllData() {
    return _$loadAllDataAsyncAction.run(() => super.loadAllData());
  }

  late final _$refreshAllAsyncAction = AsyncAction(
    'ResultsScreenControllerBase.refreshAll',
    context: context,
  );

  @override
  Future<void> refreshAll() {
    return _$refreshAllAsyncAction.run(() => super.refreshAll());
  }

  late final _$loadLastRaceResultsAsyncAction = AsyncAction(
    'ResultsScreenControllerBase.loadLastRaceResults',
    context: context,
  );

  @override
  Future<void> loadLastRaceResults() {
    return _$loadLastRaceResultsAsyncAction.run(
      () => super.loadLastRaceResults(),
    );
  }

  late final _$dismissOfflineBannerIfOnlineAsyncAction = AsyncAction(
    'ResultsScreenControllerBase.dismissOfflineBannerIfOnline',
    context: context,
  );

  @override
  Future<void> dismissOfflineBannerIfOnline() {
    return _$dismissOfflineBannerIfOnlineAsyncAction.run(
      () => super.dismissOfflineBannerIfOnline(),
    );
  }

  @override
  String toString() {
    return '''
lastRace: ${lastRace},
showingCachedData: ${showingCachedData},
screenError: ${screenError}
    ''';
  }
}
