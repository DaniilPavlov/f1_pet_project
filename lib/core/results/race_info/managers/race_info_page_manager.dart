import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/results/models/pit_stops_model.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/race_info/state/state_holders/race_info_page_state_holder.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';

/// Загружает квалификацию, пит-стопы и спринт для детального экрана гонки.
class RaceInfoPageManager {
  RaceInfoPageManager({
    required this.raceModel,
    required RaceInfoPageStateHolder holder,
    ScheduleRepository? scheduleRepository,
    RaceWeekendRepository? raceWeekendRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<bool> Function()? weekendHasSprintForTest,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchQualifyingResultsForTest,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchPitStopsForTest,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchSprintResultsForTest,
  }) : _holder = holder,
       _scheduleRepository = scheduleRepository,
       _raceWeekendRepository = raceWeekendRepository,
       _dataRefresh = dataRefresh,
       _weekendHasSprintForTest = weekendHasSprintForTest,
       _fetchQualifyingResultsForTest = fetchQualifyingResultsForTest,
       _fetchPitStopsForTest = fetchPitStopsForTest,
       _fetchSprintResultsForTest = fetchSprintResultsForTest;

  /// Информация о гонке для загрузки деталей.
  final RacesModel raceModel;
  final RaceInfoPageStateHolder _holder;
  final ScheduleRepository? _scheduleRepository;
  final RaceWeekendRepository? _raceWeekendRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<bool> Function()? _weekendHasSprintForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchQualifyingResultsForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchPitStopsForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchSprintResultsForTest;

  var _disposed = false;

  /// Загружает квалификацию, пит-стопы и спринт (только если уикенд со спринтом).
  Future<void> loadAllData() async {
    _holder.setViewModel(_holder.viewModel.copyWith(allDataIsLoaded: false));
    final loads = <Future<void>>[loadQualifyingResults(), loadPitStops()];
    if (await _weekendHasSprint()) {
      loads.add(loadSprintResults());
    } else {
      _holder.setViewModel(_holder.viewModel.copyWith(sprintResults: const Loadable.value(value: [])));
    }
    await Future.wait(loads);
    if (_disposed) {
      return;
    }
    _holder.setViewModel(
      _holder.viewModel.copyWith(allDataIsLoaded: _holder.viewModel.screenError == null),
    );
  }

  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    if (_disposed) {
      return;
    }
    await loadAllData();
  }

  /// Загружает результаты спринта; на обычном уикенде список будет пустым.
  Future<void> loadSprintResults() async {
    await runAsyncLoad<ScheduleModel, List<ResultsModel>>(
      fetch: () => _fetchSprintResults(year: raceModel.season, round: raceModel.round),
      getField: () => _holder.viewModel.sprintResults,
      setField: (value) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(_holder.viewModel.copyWith(sprintResults: value));
      },
      onSuccess: (data) {
        if (_disposed) {
          return;
        }
        if (data!.raceTable.races.isEmpty) {
          _holder.setViewModel(
            _holder.viewModel.copyWith(sprintResults: _holder.viewModel.sprintResults.toValue([])),
          );
        } else {
          _holder.setViewModel(
            _holder.viewModel.copyWith(
              sprintResults: _holder.viewModel.sprintResults.toValue(
                data.raceTable.races[0].sprintResults ?? [],
              ),
            ),
          );
        }
      },
    );
  }

  /// Загружает результаты квалификации для текущей гонки.
  Future<void> loadQualifyingResults() async {
    await runAsyncLoad<ScheduleModel, List<QualifyingResultsModel>>(
      fetch: () => _fetchQualifyingResults(year: raceModel.season, round: raceModel.round),
      getField: () => _holder.viewModel.qualifyingResults,
      setField: (value) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(_holder.viewModel.copyWith(qualifyingResults: value));
      },
      onSuccess: (data) {
        if (_disposed) {
          return;
        }
        if (data!.raceTable.races.isEmpty) {
          _holder.setViewModel(
            _holder.viewModel.copyWith(
              qualifyingResults: _holder.viewModel.qualifyingResults.toValue([]),
            ),
          );
        } else {
          _holder.setViewModel(
            _holder.viewModel.copyWith(
              qualifyingResults: _holder.viewModel.qualifyingResults.toValue(
                data.raceTable.races[0].qualifyingResults ?? [],
              ),
            ),
          );
        }
      },
    );
  }

  /// Загружает пит-стопы и подставляет имена пилотов из уже известных данных гонки.
  Future<void> loadPitStops() async {
    await runAsyncLoad<ScheduleModel, List<PitStopsModel>>(
      fetch: () => _fetchPitStops(year: raceModel.season, round: raceModel.round),
      getField: () => _holder.viewModel.pitStops,
      setField: (value) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(_holder.viewModel.copyWith(pitStops: value));
      },
      onSuccess: (data) {
        if (_disposed) {
          return;
        }
        if (data!.raceTable.races.isEmpty) {
          _holder.setViewModel(
            _holder.viewModel.copyWith(pitStops: _holder.viewModel.pitStops.toValue([])),
          );
        } else {
          final stops = data.raceTable.races[0].pitStops ?? [];
          _holder.setViewModel(
            _holder.viewModel.copyWith(pitStops: _holder.viewModel.pitStops.toValue(_withDriverNames(stops))),
          );
        }
      },
    );
  }

  /// Очищает ресурсы менеджера.
  void dispose() {
    _disposed = true;
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
    for (final result in _holder.viewModel.sprintResults.value ?? const <ResultsModel>[]) {
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
    return _raceWeekendRepository!.sprintResults(year: year, round: round);
  }

  Future<ScheduleModel> _fetchQualifyingResults({required String year, required String round}) {
    final forTest = _fetchQualifyingResultsForTest;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository!.qualifyingResults(year: year, round: round);
  }

  Future<ScheduleModel> _fetchPitStops({required String year, required String round}) {
    final forTest = _fetchPitStopsForTest;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository!.pitStops(year: year, round: round);
  }
}
