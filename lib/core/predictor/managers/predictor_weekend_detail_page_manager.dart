import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_comparison.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_score_service.dart';
import 'package:f1_pet_project/core/predictor/state/state_holders/predictor_weekend_detail_page_state_holder.dart';
import 'package:f1_pet_project/core/predictor/state/state_models/predictor_weekend_detail_page_args.dart';
import 'package:f1_pet_project/core/predictor/state/state_models/predictor_weekend_detail_page_view_model.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter/foundation.dart';

/// Загружает actuals квалификации/гонки и строит [PredictorSessionCompare].
class PredictorWeekendDetailPageManager {
  PredictorWeekendDetailPageManager({
    required this.args,
    required PredictorWeekendDetailPageStateHolder holder,
    RaceWeekendRepository? raceWeekendRepository,
    DriverCatalogRepository? driverCatalogRepository,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchQualifyingForTest,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchRaceResultsForTest,
    @visibleForTesting Future<List<DriverModel>> Function()? loadDriversForTest,
    @visibleForTesting RaceWeekendRepository? raceWeekendRepositoryForTest,
  }) : _holder = holder,
       _raceWeekendRepository = raceWeekendRepositoryForTest ?? raceWeekendRepository,
       _driverCatalogRepository = driverCatalogRepository,
       _fetchQualifyingForTest = fetchQualifyingForTest,
       _fetchRaceResultsForTest = fetchRaceResultsForTest,
       _loadDriversForTest = loadDriversForTest;

  /// Аргументы экрана: сезон и уикенд для сравнения.
  final PredictorWeekendDetailPageArgs args;
  final PredictorWeekendDetailPageStateHolder _holder;
  final RaceWeekendRepository? _raceWeekendRepository;
  final DriverCatalogRepository? _driverCatalogRepository;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchQualifyingForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchRaceResultsForTest;
  final Future<List<DriverModel>> Function()? _loadDriversForTest;

  var _disposed = false;

  /// Год сезона.
  String get season => args.season;
  /// Предикт уикенда.
  PredictorWeekendPrediction get weekend => args.weekend;

  /// Переключает между квалификацией и гонкой.
  void selectSession(PredictorDetailSession session) {
    _holder.setViewModel(_holder.viewModel.copyWith(selectedSession: session));
  }

  /// Загружает фактические результаты и строит сравнения.
  Future<void> load() async {
    _holder.setViewModel(_holder.viewModel.copyWith(allDataIsLoaded: false));
    await Future.wait([_loadDriversMap(), _loadQualifying(), _loadRace()]);
    if (_disposed) {
      return;
    }
    final viewModel = _holder.viewModel;
    _holder.setViewModel(
      viewModel.copyWith(
        allDataIsLoaded: viewModel.screenError == null ||
            viewModel.qualifyingCompare.value != null ||
            viewModel.raceCompare.value != null,
      ),
    );
  }

  Future<void> refreshAll() => load();

  /// Очищает ресурсы менеджера.
  void dispose() => _disposed = true;

  Future<void> _loadDriversMap() async {
    try {
      final list = await _loadDrivers();
      if (_disposed) {
        return;
      }
      _holder.setViewModel(
        _holder.viewModel.copyWith(driversById: {for (final d in list) d.driverId: d}),
      );
    } on Object {
      // Каталог опционален — подписи упадут на driverId.
    }
  }

  Future<void> _loadQualifying() async {
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
      getField: () => _holder.viewModel.qualifyingCompare,
      setField: (value) => _holder.setViewModel(_holder.viewModel.copyWith(qualifyingCompare: value)),
      onSuccess: (actual) {
        _holder.setViewModel(
          _holder.viewModel.copyWith(
            qualifyingCompare: _holder.viewModel.qualifyingCompare.toValue(
              PredictorSessionCompare.fromOrders(
                predicted: weekend.qualifyingOrder,
                actual: actual ?? const [],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadRace() async {
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
      getField: () => _holder.viewModel.raceCompare,
      setField: (value) => _holder.setViewModel(_holder.viewModel.copyWith(raceCompare: value)),
      onSuccess: (actual) {
        _holder.setViewModel(
          _holder.viewModel.copyWith(
            raceCompare: _holder.viewModel.raceCompare.toValue(
              PredictorSessionCompare.fromOrders(
                predicted: weekend.raceOrder,
                actual: actual ?? const [],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<DriverModel>> _loadDrivers() {
    final forTest = _loadDriversForTest;
    if (forTest != null) {
      return forTest();
    }
    return _driverCatalogRepository!.loadCurrent();
  }

  Future<ScheduleModel> _fetchQualifying({required String year, required String round}) {
    final forTest = _fetchQualifyingForTest;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository!.qualifyingResults(year: year, round: round);
  }

  Future<ScheduleModel> _fetchRaceResults({required String year, required String round}) {
    final forTest = _fetchRaceResultsForTest;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository!.raceResults(year: year, round: round);
  }
}
