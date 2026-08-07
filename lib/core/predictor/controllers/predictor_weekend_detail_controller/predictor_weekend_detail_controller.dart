import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_comparison.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_score_service.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Какая сессия показана на экране сравнения.
enum PredictorDetailSession { qualifying, race }

/// Аргументы семейства экрана сравнения уикенда.
@immutable
class PredictorWeekendDetailArgs {
  const PredictorWeekendDetailArgs({required this.season, required this.weekend});

  final String season;
  final PredictorWeekendPrediction weekend;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PredictorWeekendDetailArgs && season == other.season && weekend.round == other.weekend.round;

  @override
  int get hashCode => Object.hash(season, weekend.round);
}

/// Состояние экрана сравнения предикта с фактом.
@immutable
class PredictorWeekendDetailState {
  const PredictorWeekendDetailState({
    this.qualifyingCompare = const Loadable.loading(),
    this.raceCompare = const Loadable.loading(),
    this.driversById = const {},
    this.selectedSession = PredictorDetailSession.qualifying,
    this.allDataIsLoaded = false,
  });

  final Loadable<PredictorSessionCompare> qualifyingCompare;
  final Loadable<PredictorSessionCompare> raceCompare;
  final Map<String, DriverModel> driversById;
  final PredictorDetailSession selectedSession;
  final bool allDataIsLoaded;

  CustomException? get screenError => firstException([qualifyingCompare, raceCompare]);

  PredictorSessionCompare? get activeCompare =>
      selectedSession == PredictorDetailSession.qualifying ? qualifyingCompare.value : raceCompare.value;

  PredictorWeekendDetailState copyWith({
    Loadable<PredictorSessionCompare>? qualifyingCompare,
    Loadable<PredictorSessionCompare>? raceCompare,
    Map<String, DriverModel>? driversById,
    PredictorDetailSession? selectedSession,
    bool? allDataIsLoaded,
  }) {
    return PredictorWeekendDetailState(
      qualifyingCompare: qualifyingCompare ?? this.qualifyingCompare,
      raceCompare: raceCompare ?? this.raceCompare,
      driversById: driversById ?? this.driversById,
      selectedSession: selectedSession ?? this.selectedSession,
      allDataIsLoaded: allDataIsLoaded ?? this.allDataIsLoaded,
    );
  }
}

/// Загружает actuals квалификации/гонки и строит [PredictorSessionCompare].
class PredictorWeekendDetailController extends Notifier<PredictorWeekendDetailState> {
  PredictorWeekendDetailController(
    this.args, {
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchQualifyingForTest,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchRaceResultsForTest,
    @visibleForTesting Future<List<DriverModel>> Function()? loadDriversForTest,
    @visibleForTesting RaceWeekendRepository? raceWeekendRepositoryForTest,
  }) : _fetchQualifyingForTest = fetchQualifyingForTest,
       _fetchRaceResultsForTest = fetchRaceResultsForTest,
       _loadDriversForTest = loadDriversForTest,
       _raceWeekendRepositoryForTest = raceWeekendRepositoryForTest;

  final PredictorWeekendDetailArgs args;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchQualifyingForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchRaceResultsForTest;
  final Future<List<DriverModel>> Function()? _loadDriversForTest;
  final RaceWeekendRepository? _raceWeekendRepositoryForTest;

  String get season => args.season;
  PredictorWeekendPrediction get weekend => args.weekend;

  RaceWeekendRepository get _raceWeekendRepository =>
      _raceWeekendRepositoryForTest ?? ref.read(raceWeekendRepositoryProvider);

  @override
  PredictorWeekendDetailState build() => const PredictorWeekendDetailState();

  void selectSession(PredictorDetailSession session) {
    state = state.copyWith(selectedSession: session);
  }

  Future<void> load() async {
    state = state.copyWith(allDataIsLoaded: false);
    await Future.wait([_loadDriversMap(), _loadQualifying(), _loadRace()]);
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(
      allDataIsLoaded: state.screenError == null || state.qualifyingCompare.value != null || state.raceCompare.value != null,
    );
  }

  Future<void> refreshAll() => load();

  Future<void> _loadDriversMap() async {
    try {
      final list = await _loadDrivers();
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(driversById: {for (final d in list) d.driverId: d});
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
      getField: () => state.qualifyingCompare,
      setField: (value) => state = state.copyWith(qualifyingCompare: value),
      onSuccess: (actual) {
        state = state.copyWith(
          qualifyingCompare: state.qualifyingCompare.toValue(
            PredictorSessionCompare.fromOrders(
              predicted: weekend.qualifyingOrder,
              actual: actual ?? const [],
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
      getField: () => state.raceCompare,
      setField: (value) => state = state.copyWith(raceCompare: value),
      onSuccess: (actual) {
        state = state.copyWith(
          raceCompare: state.raceCompare.toValue(
            PredictorSessionCompare.fromOrders(
              predicted: weekend.raceOrder,
              actual: actual ?? const [],
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
    return ref.read(driverCatalogRepositoryProvider).loadCurrent();
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

final predictorWeekendDetailControllerProvider = NotifierProvider.autoDispose
    .family<PredictorWeekendDetailController, PredictorWeekendDetailState, PredictorWeekendDetailArgs>(
      PredictorWeekendDetailController.new,
    );
