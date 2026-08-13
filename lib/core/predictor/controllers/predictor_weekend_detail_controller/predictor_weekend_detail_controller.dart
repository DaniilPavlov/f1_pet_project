import 'dart:async';

import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/network_reachability.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_comparison.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_score_service.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'predictor_weekend_detail_controller.g.dart';

/// Какая сессия показана на экране сравнения.
enum PredictorDetailSession { qualifying, race }

/// MobX-контроллер экрана сравнения предикта с фактом.
class PredictorWeekendDetailController = PredictorWeekendDetailControllerBase
    with _$PredictorWeekendDetailController;

/// Загружает actuals квалификации/гонки и строит [PredictorSessionCompare].
abstract class PredictorWeekendDetailControllerBase with Store {
  PredictorWeekendDetailControllerBase({
    required this.season,
    required this.weekend,
    RaceWeekendRepository? raceWeekendRepository,
    DriverCatalogRepository? driverCatalogRepository,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchQualifyingForTest,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchRaceResultsForTest,
    @visibleForTesting Future<List<DriverModel>> Function()? loadDriversForTest,
  }) : _raceWeekendRepository = raceWeekendRepository ?? const RaceWeekendRepository(),
       _fetchQualifyingForTest = fetchQualifyingForTest,
       _fetchRaceResultsForTest = fetchRaceResultsForTest,
       _loadDrivers = loadDriversForTest ?? driverCatalogRepository!.loadCurrent;

  final String season;
  final PredictorWeekendPrediction weekend;
  final RaceWeekendRepository _raceWeekendRepository;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchQualifyingForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchRaceResultsForTest;
  final Future<List<DriverModel>> Function() _loadDrivers;

  /// Жёсткий потолок ожидания сети.
  static const _detailLoadTimeout = Duration(seconds: 40);

  /// Поколение [load]: после таймаута отсекаем поздние setField(toLoading).
  int _loadEpoch = 0;

  @observable
  AsyncValue<PredictorSessionCompare> qualifyingCompare = const AsyncValue.loading();

  @observable
  AsyncValue<PredictorSessionCompare> raceCompare = const AsyncValue.loading();

  @observable
  ObservableMap<String, DriverModel> driversById = ObservableMap();

  @observable
  PredictorDetailSession selectedSession = PredictorDetailSession.qualifying;

  @observable
  bool allDataIsLoaded = false;

  bool _isLoadEpoch(int epoch) => epoch == _loadEpoch;

  @computed
  CustomException? get screenError => firstException([qualifyingCompare, raceCompare]);

  @computed
  PredictorSessionCompare? get activeCompare =>
      selectedSession == PredictorDetailSession.qualifying ? qualifyingCompare.value : raceCompare.value;

  @action
  void selectSession(PredictorDetailSession session) {
    selectedSession = session;
  }

  @action
  Future<void> load() async {
    final epoch = ++_loadEpoch;
    allDataIsLoaded = false;
    qualifyingCompare = const AsyncValue.loading();
    raceCompare = const AsyncValue.loading();

    if (await NetworkReachability.isOffline()) {
      if (!_isLoadEpoch(epoch)) {
        return;
      }
      final exception = CustomException(
        title: ErrorCopy.noConnection,
        subtitle: ErrorCopy.noConnectionSubtitle,
      );
      qualifyingCompare = qualifyingCompare.toErrorFrom(exception);
      raceCompare = raceCompare.toErrorFrom(exception);
      allDataIsLoaded = false;
      return;
    }

    try {
      await Future.wait([
        _loadDriversMap(epoch),
        _loadQualifying(epoch),
        _loadRace(epoch),
      ]).timeout(_detailLoadTimeout);
    } on TimeoutException catch (e, st) {
      if (!_isLoadEpoch(epoch)) {
        return;
      }
      final exception = CustomException(
        title: ErrorCopy.noConnection,
        subtitle: ErrorCopy.noConnectionSubtitle,
        parentException: e,
        stackTrace: st,
      );
      if (qualifyingCompare.exception == null && qualifyingCompare.value == null) {
        qualifyingCompare = qualifyingCompare.toErrorFrom(exception);
      }
      if (raceCompare.exception == null && raceCompare.value == null) {
        raceCompare = raceCompare.toErrorFrom(exception);
      }
      _loadEpoch++;
      allDataIsLoaded = qualifyingCompare.value != null || raceCompare.value != null;
      return;
    }
    if (!_isLoadEpoch(epoch)) {
      return;
    }
    if (screenError?.title == ErrorCopy.noConnection &&
        qualifyingCompare.value == null &&
        raceCompare.value == null) {
      allDataIsLoaded = false;
      return;
    }
    allDataIsLoaded = screenError == null || qualifyingCompare.value != null || raceCompare.value != null;
  }

  @action
  Future<void> refreshAll() => load();

  @action
  Future<void> _loadDriversMap(int epoch) async {
    try {
      final list = await _loadDrivers();
      if (!_isLoadEpoch(epoch)) {
        return;
      }
      driversById = ObservableMap.of({for (final d in list) d.driverId: d});
    } on Object {
      // Каталог опционален — подписи упадут на driverId.
    }
  }

  @action
  Future<void> _loadQualifying(int epoch) async {
    await runAsyncLoad<List<String>, PredictorSessionCompare>(
      fetch: () async {
        final cached = weekend.actualQualifyingOrder;
        if (cached != null && cached.isNotEmpty) {
          return cached;
        }
        try {
          final model = await _fetchQualifying(year: season, round: weekend.round);
          final results = model.raceTable.races.isEmpty
              ? const <QualifyingResultsModel>[]
              : (model.raceTable.races.first.qualifyingResults ?? const <QualifyingResultsModel>[]);
          return PredictorScoreService.qualifyingActualOrder(results);
        } on Object {
          return const <String>[];
        }
      },
      getField: () => qualifyingCompare,
      setField: (value) {
        if (!_isLoadEpoch(epoch)) {
          return;
        }
        qualifyingCompare = value;
      },
      onSuccess: (actual) {
        if (!_isLoadEpoch(epoch)) {
          return;
        }
        qualifyingCompare = qualifyingCompare.toValue(
          PredictorSessionCompare.fromOrders(
            predicted: weekend.qualifyingOrder,
            actual: actual ?? const [],
          ),
        );
      },
    );
  }

  @action
  Future<void> _loadRace(int epoch) async {
    await runAsyncLoad<List<String>, PredictorSessionCompare>(
      fetch: () async {
        final cached = weekend.actualRaceOrder;
        if (cached != null && cached.isNotEmpty) {
          return cached;
        }
        try {
          final model = await _fetchRaceResults(year: season, round: weekend.round);
          final results = model.raceTable.races.isEmpty
              ? const <ResultsModel>[]
              : (model.raceTable.races.first.results ?? const <ResultsModel>[]);
          return PredictorScoreService.raceActualOrder(results);
        } on Object {
          return const <String>[];
        }
      },
      getField: () => raceCompare,
      setField: (value) {
        if (!_isLoadEpoch(epoch)) {
          return;
        }
        raceCompare = value;
      },
      onSuccess: (actual) {
        if (!_isLoadEpoch(epoch)) {
          return;
        }
        raceCompare = raceCompare.toValue(
          PredictorSessionCompare.fromOrders(
            predicted: weekend.raceOrder,
            actual: actual ?? const [],
          ),
        );
      },
    );
  }

  Future<ScheduleModel> _fetchQualifying({required String year, required String round}) {
    final forTest = _fetchQualifyingForTest;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository.qualifyingResults(year: year, round: round);
  }

  Future<ScheduleModel> _fetchRaceResults({required String year, required String round}) {
    final forTest = _fetchRaceResultsForTest;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository.raceResults(year: year, round: round);
  }
}
