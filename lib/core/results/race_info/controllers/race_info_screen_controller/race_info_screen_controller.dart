import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/results/models/pit_stops_model.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние детального экрана гонки.
@immutable
class RaceInfoState {
  const RaceInfoState({
    this.allDataIsLoaded = false,
    this.sprintResults = const Loadable.loading(),
    this.qualifyingResults = const Loadable.loading(),
    this.pitStops = const Loadable.loading(),
  });

  final bool allDataIsLoaded;
  final Loadable<List<ResultsModel>> sprintResults;
  final Loadable<List<QualifyingResultsModel>> qualifyingResults;
  final Loadable<List<PitStopsModel>> pitStops;

  CustomException? get screenError => firstException([sprintResults, qualifyingResults, pitStops]);

  /// Есть ли результаты спринта для отображения.
  bool get hasSprintResults => sprintResults.value?.isNotEmpty ?? false;

  RaceInfoState copyWith({
    bool? allDataIsLoaded,
    Loadable<List<ResultsModel>>? sprintResults,
    Loadable<List<QualifyingResultsModel>>? qualifyingResults,
    Loadable<List<PitStopsModel>>? pitStops,
  }) {
    return RaceInfoState(
      allDataIsLoaded: allDataIsLoaded ?? this.allDataIsLoaded,
      sprintResults: sprintResults ?? this.sprintResults,
      qualifyingResults: qualifyingResults ?? this.qualifyingResults,
      pitStops: pitStops ?? this.pitStops,
    );
  }
}

/// Управляет данными гонки, спринта, квалификации и пит-стопов.
class RaceInfoScreenController extends Notifier<RaceInfoState> {
  RaceInfoScreenController(
    this.raceModel, {
    @visibleForTesting ScheduleRepository? scheduleRepositoryForTest,
    @visibleForTesting Future<bool> Function()? weekendHasSprintForTest,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchQualifyingResultsForTest,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchPitStopsForTest,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchSprintResultsForTest,
    @visibleForTesting AppDataRefresh? dataRefreshForTest,
  }) : _scheduleRepositoryForTest = scheduleRepositoryForTest,
       _weekendHasSprintForTest = weekendHasSprintForTest,
       _fetchQualifyingResultsForTest = fetchQualifyingResultsForTest,
       _fetchPitStopsForTest = fetchPitStopsForTest,
       _fetchSprintResultsForTest = fetchSprintResultsForTest,
       _dataRefreshForTest = dataRefreshForTest;

  final RacesModel raceModel;
  final ScheduleRepository? _scheduleRepositoryForTest;
  final Future<bool> Function()? _weekendHasSprintForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchQualifyingResultsForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchPitStopsForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchSprintResultsForTest;
  final AppDataRefresh? _dataRefreshForTest;

  ScheduleRepository? get _scheduleRepository {
    if (_scheduleRepositoryForTest != null) {
      return _scheduleRepositoryForTest;
    }
    if (_usingTestFetches) {
      return null;
    }
    return ref.read(scheduleRepositoryProvider);
  }

  RaceWeekendRepository get _raceWeekendRepository => ref.read(raceWeekendRepositoryProvider);

  bool get _usingTestFetches =>
      _weekendHasSprintForTest != null ||
      _fetchQualifyingResultsForTest != null ||
      _fetchPitStopsForTest != null ||
      _fetchSprintResultsForTest != null;

  @override
  RaceInfoState build() => const RaceInfoState();

  /// Загружает квалификацию, пит-стопы и спринт (только если уикенд со спринтом).
  Future<void> loadAllData() async {
    state = state.copyWith(allDataIsLoaded: false);
    final loads = <Future<void>>[loadQualifyingResults(), loadPitStops()];
    if (await _weekendHasSprint()) {
      loads.add(loadSprintResults());
    } else {
      state = state.copyWith(sprintResults: const Loadable.value(value: []));
    }
    await Future.wait(loads);
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(allDataIsLoaded: state.screenError == null);
  }

  /// Pull-to-refresh / ErrorBody: сброс кэшей и перезагрузка секций.
  Future<void> refreshAll() async {
    if (_dataRefreshForTest != null) {
      await _dataRefreshForTest.clearAll();
    } else if (!_usingTestFetches) {
      await ref.read(appDataRefreshProvider).clearAll();
    }
    await loadAllData();
  }

  /// Results API не отдаёт расписание сессий — смотрим [RacesModel.sprint] или кэш календаря.
  Future<bool> _weekendHasSprint() async {
    if (raceModel.sprint != null) {
      return true;
    }
    final forTest = _weekendHasSprintForTest;
    if (forTest != null) {
      return forTest();
    }
    final repository = _scheduleRepository;
    if (repository == null) {
      return true;
    }
    try {
      final schedule = (await repository.getSchedule()).schedule;
      for (final race in schedule.raceTable.races) {
        if (race.season == raceModel.season && race.round == raceModel.round) {
          return race.sprint != null;
        }
      }
      // Гонки нет в текущем календаре (поиск по прошлому сезону) — подстраховываемся запросом.
      return true;
    } on Object {
      return true;
    }
  }

  /// Загружает результаты спринта; на обычном уикенде список будет пустым.
  Future<void> loadSprintResults() async {
    await runAsyncLoad<ScheduleModel, List<ResultsModel>>(
      fetch: () => _fetchSprintResults(year: raceModel.season, round: raceModel.round),
      getField: () => state.sprintResults,
      setField: (value) => state = state.copyWith(sprintResults: value),
      onSuccess: (data) {
        if (data!.raceTable.races.isEmpty) {
          state = state.copyWith(sprintResults: state.sprintResults.toValue([]));
        } else {
          state = state.copyWith(
            sprintResults: state.sprintResults.toValue(data.raceTable.races[0].sprintResults ?? []),
          );
        }
      },
    );
  }

  /// Загружает результаты квалификации для текущей гонки.
  Future<void> loadQualifyingResults() async {
    await runAsyncLoad<ScheduleModel, List<QualifyingResultsModel>>(
      fetch: () => _fetchQualifyingResults(year: raceModel.season, round: raceModel.round),
      getField: () => state.qualifyingResults,
      setField: (value) => state = state.copyWith(qualifyingResults: value),
      onSuccess: (data) {
        if (data!.raceTable.races.isEmpty) {
          state = state.copyWith(qualifyingResults: state.qualifyingResults.toValue([]));
        } else {
          state = state.copyWith(
            qualifyingResults: state.qualifyingResults.toValue(data.raceTable.races[0].qualifyingResults ?? []),
          );
        }
      },
    );
  }

  /// Загружает пит-стопы и подставляет имена пилотов из уже известных данных гонки.
  Future<void> loadPitStops() async {
    await runAsyncLoad<ScheduleModel, List<PitStopsModel>>(
      fetch: () => _fetchPitStops(year: raceModel.season, round: raceModel.round),
      getField: () => state.pitStops,
      setField: (value) => state = state.copyWith(pitStops: value),
      onSuccess: (data) {
        if (data!.raceTable.races.isEmpty) {
          state = state.copyWith(pitStops: state.pitStops.toValue([]));
        } else {
          final stops = data.raceTable.races[0].pitStops ?? [];
          state = state.copyWith(pitStops: state.pitStops.toValue(_withDriverNames(stops)));
        }
      },
    );
  }

  /// Имена берутся из результатов/квалификации гонки — без отдельных API-запросов на каждого пилота.
  List<PitStopsModel> _withDriverNames(List<PitStopsModel> stops) {
    final names = <String, String>{};

    for (final result in raceModel.results ?? const <ResultsModel>[]) {
      final driver = result.driver;
      names[driver.driverId] = '${driver.givenName} ${driver.familyName}';
    }
    for (final result in raceModel.qualifyingResults ?? const <QualifyingResultsModel>[]) {
      final driver = result.driver;
      names.putIfAbsent(driver.driverId, () => '${driver.givenName} ${driver.familyName}');
    }
    for (final result in state.sprintResults.value ?? const <ResultsModel>[]) {
      final driver = result.driver;
      names.putIfAbsent(driver.driverId, () => '${driver.givenName} ${driver.familyName}');
    }

    return [for (final stop in stops) stop.copyWith(driverId: names[stop.driverId] ?? stop.driverId)];
  }

  Future<ScheduleModel> _fetchSprintResults({required String year, required String round}) {
    final forTest = _fetchSprintResultsForTest;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository.sprintResults(year: year, round: round);
  }

  Future<ScheduleModel> _fetchQualifyingResults({required String year, required String round}) {
    final forTest = _fetchQualifyingResultsForTest;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository.qualifyingResults(year: year, round: round);
  }

  Future<ScheduleModel> _fetchPitStops({required String year, required String round}) {
    final forTest = _fetchPitStopsForTest;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository.pitStops(year: year, round: round);
  }
}

final raceInfoScreenControllerProvider =
    NotifierProvider.autoDispose.family<RaceInfoScreenController, RaceInfoState, RacesModel>(
      RaceInfoScreenController.new,
    );
