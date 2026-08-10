import 'dart:async';

import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_season.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_leaderboard_repository.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_repository.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_lock.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_lock_ticker.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_order.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_scoring_coordinator.dart';
import 'package:f1_pet_project/core/predictor/state/state_holders/predictor_page_state_holder.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';

/// Upcoming weekend, локальные предикты, lock и автоскоринг.
class PredictorPageManager {
  PredictorPageManager({
    required PredictorPageStateHolder holder,
    PredictorRepository? predictorRepository,
    PredictorLeaderboardRepository? leaderboardRepository,
    ScheduleRepository? scheduleRepository,
    CurrentStandingsRepository? standingsRepository,
    DriverCatalogRepository? driverCatalogRepository,
    RaceWeekendRepository? raceWeekendRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting PredictorRepository? predictorRepositoryForTest,
    @visibleForTesting PredictorLeaderboardRepository? leaderboardRepositoryForTest,
    @visibleForTesting Future<ScheduleModel> Function()? fetchScheduleForTest,
    @visibleForTesting Future<List<DriverModel>> Function()? loadDriversForTest,
    @visibleForTesting Future<StandingsModel> Function()? fetchDriverStandingsForTest,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchQualifyingForTest,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchRaceResultsForTest,
    @visibleForTesting RaceWeekendRepository? raceWeekendRepositoryForTest,
  }) : _holder = holder,
       _predictorRepository = predictorRepositoryForTest ?? predictorRepository,
       _leaderboardRepository = leaderboardRepositoryForTest ??
           (predictorRepositoryForTest != null ? null : leaderboardRepository),
       _scheduleRepository = fetchScheduleForTest != null ? null : scheduleRepository,
       _standingsRepository = fetchDriverStandingsForTest != null ? null : standingsRepository,
       _driverCatalogRepository = driverCatalogRepository,
       _raceWeekendRepository = raceWeekendRepositoryForTest ??
           (predictorRepositoryForTest != null ? const RaceWeekendRepository() : raceWeekendRepository),
       _dataRefresh = predictorRepositoryForTest != null ? null : dataRefresh,
       _fetchScheduleForTest = fetchScheduleForTest,
       _loadDriversForTest = loadDriversForTest,
       _fetchDriverStandingsForTest = fetchDriverStandingsForTest,
       _fetchQualifyingForTest = fetchQualifyingForTest,
       _fetchRaceResultsForTest = fetchRaceResultsForTest;

  final PredictorPageStateHolder _holder;
  final PredictorRepository? _predictorRepository;
  final PredictorLeaderboardRepository? _leaderboardRepository;
  final ScheduleRepository? _scheduleRepository;
  final CurrentStandingsRepository? _standingsRepository;
  final DriverCatalogRepository? _driverCatalogRepository;
  final RaceWeekendRepository? _raceWeekendRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<ScheduleModel> Function()? _fetchScheduleForTest;
  final Future<List<DriverModel>> Function()? _loadDriversForTest;
  final Future<StandingsModel> Function()? _fetchDriverStandingsForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchQualifyingForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchRaceResultsForTest;

  late final PredictorLockTicker _ticker = PredictorLockTicker(onTick: _tickNow);
  PredictorScoringCoordinator? _scoring;
  var _disposed = false;

  /// Season+round текущего драфта для перезагрузки порядка при смене уикенда.
  String? _boundDraftKey;

  PredictorScoringCoordinator get _scoringCoordinator {
    return _scoring ??= PredictorScoringCoordinator(
      raceWeekendRepository: _raceWeekendRepository ?? const RaceWeekendRepository(),
      fetchQualifying: _fetchQualifyingForTest,
      fetchRaceResults: _fetchRaceResultsForTest,
    );
  }

  /// Возвращает сезон по году.
  PredictorSeason? seasonByYear(String year) => _holder.viewModel.store.season(year);

  /// Первичная загрузка расписания, ростера, команд и store.
  Future<void> load() async {
    _holder.setViewModel(
      _holder.viewModel.copyWith(allDataIsLoaded: false, predictions: const Loadable.loading()),
    );
    await Future.wait([_loadSchedule(), _loadDriversList(), _loadConstructorsByDriver()]);
    if (_disposed) {
      return;
    }
    await _loadPredictionsStore();
    if (_disposed) {
      return;
    }

    if (_holder.viewModel.screenError == null) {
      await _ensureCurrentDraft();
      if (_disposed) {
        return;
      }
      await _scoreAllPending();
      if (_disposed) {
        return;
      }
      await _syncLeaderboardPoints();
      _ticker.start();
    }

    if (_disposed) {
      return;
    }
    _holder.setViewModel(
      _holder.viewModel.copyWith(allDataIsLoaded: _holder.viewModel.screenError == null),
    );
  }

  /// Переключает вкладку (квалификация / гонка).
  void selectGrid(PredictorGridKind kind) {
    _holder.setViewModel(_holder.viewModel.copyWith(selectedGrid: kind));
  }

  /// Pull-to-refresh: сброс API-кэшей, предикты не трогаем.
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    if (_disposed) {
      return;
    }
    await load();
  }

  /// Drag-reorder: remove + insert (сдвигает соседей). Для точечной смены места — [moveDraftTo].
  Future<void> reorderDraft({required int oldIndex, required int newIndex}) async {
    final viewModel = _holder.viewModel;
    if (viewModel.isLocked || oldIndex == newIndex) {
      return;
    }
    final list = List<String>.from(
      viewModel.selectedGrid == PredictorGridKind.qualifying
          ? viewModel.draftQualifyingOrder
          : viewModel.draftRaceOrder,
    );
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    _holder.setViewModel(
      viewModel.selectedGrid == PredictorGridKind.qualifying
          ? viewModel.copyWith(draftQualifyingOrder: list)
          : viewModel.copyWith(draftRaceOrder: list),
    );
    await _persistDraft();
  }

  /// Меняет местами пилотов на [fromIndex] и [toIndex] (0 = P1).
  /// Остальные позиции не сдвигаются.
  Future<void> moveDraftTo({required int fromIndex, required int toIndex}) async {
    final viewModel = _holder.viewModel;
    if (viewModel.isLocked || fromIndex == toIndex) {
      return;
    }
    final list = List<String>.from(
      viewModel.selectedGrid == PredictorGridKind.qualifying
          ? viewModel.draftQualifyingOrder
          : viewModel.draftRaceOrder,
    );
    if (fromIndex < 0 || fromIndex >= list.length) {
      return;
    }
    final target = toIndex.clamp(0, list.length - 1);
    if (fromIndex == target) {
      return;
    }
    final temp = list[fromIndex];
    list[fromIndex] = list[target];
    list[target] = temp;
    _holder.setViewModel(
      viewModel.selectedGrid == PredictorGridKind.qualifying
          ? viewModel.copyWith(draftQualifyingOrder: list)
          : viewModel.copyWith(draftRaceOrder: list),
    );
    await _persistDraft();
  }

  /// Копирует текущий предикт квалификации в гонку.
  Future<void> copyQualifyingToRace() async {
    final viewModel = _holder.viewModel;
    if (viewModel.isLocked || viewModel.draftQualifyingOrder.isEmpty) {
      return;
    }
    _holder.setViewModel(
      viewModel.copyWith(draftRaceOrder: List<String>.from(viewModel.draftQualifyingOrder)),
    );
    await _persistDraft();
  }

  /// Очищает ресурсы менеджера и тикер блокировки.
  void dispose() {
    _disposed = true;
    _ticker.dispose();
  }

  Future<void> _loadPredictionsStore() async {
    try {
      final loaded = await _predictorRepository!.load();
      if (_disposed) {
        return;
      }
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          store: loaded,
          predictions: _holder.viewModel.predictions.toValue(loaded),
        ),
      );
    } on Object catch (e, st) {
      if (_disposed) {
        return;
      }
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          predictions: _holder.viewModel.predictions.toErrorFrom(
            CustomException(
              title: ErrorCopy.unexpectedError,
              subtitle: ErrorCopy.errorRetrySubtitle,
              parentException: e is Exception ? e : null,
              stackTrace: st,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _ensureCurrentDraft() async {
    final viewModel = _holder.viewModel;
    final race = viewModel.upcomingRace;
    final roster = viewModel.drivers.value;
    if (race == null || roster == null || roster.isEmpty) {
      _holder.setViewModel(
        viewModel.copyWith(draftQualifyingOrder: const [], draftRaceOrder: const []),
      );
      _boundDraftKey = null;
      return;
    }

    final year = race.season;
    final existing = viewModel.store.weekend(year: year, round: race.round);
    final rosterIds = roster.map((d) => d.driverId).toList();
    _boundDraftKey = '${race.season}_${race.round}';

    if (existing == null) {
      final initial = defaultPredictorOrder(
        rosterIds: rosterIds,
        championshipOrder: viewModel.championshipDriverOrder,
      );
      _holder.setViewModel(
        viewModel.copyWith(
          draftQualifyingOrder: List<String>.from(initial),
          draftRaceOrder: List<String>.from(initial),
        ),
      );
      await _persistDraft(raceName: race.raceName, round: race.round, year: year);
      return;
    }

    if (PredictorLock.isLocked(race, viewModel.now)) {
      _holder.setViewModel(
        viewModel.copyWith(
          draftQualifyingOrder: List<String>.from(existing.qualifyingOrder),
          draftRaceOrder: List<String>.from(existing.raceOrder),
        ),
      );
      if (existing.lockedAt == null) {
        final repository = _predictorRepository!;
        await repository.saveWeekend(
          year: year,
          weekend: existing.copyWith(lockedAt: PredictorLock.lockAt(race) ?? viewModel.now),
        );
        if (_disposed) {
          return;
        }
        _holder.setViewModel(
          _holder.viewModel.copyWith(store: await repository.load()),
        );
      }
      return;
    }

    _holder.setViewModel(
      viewModel.copyWith(
        draftQualifyingOrder: syncOrderToRoster(existing.qualifyingOrder, rosterIds),
        draftRaceOrder: syncOrderToRoster(existing.raceOrder, rosterIds),
      ),
    );
    await _persistDraft(raceName: race.raceName, round: race.round, year: year);
  }

  Future<void> _persistDraft({String? raceName, String? round, String? year}) async {
    final viewModel = _holder.viewModel;
    final race = viewModel.upcomingRace;
    final y = year ?? race?.season;
    final r = round ?? race?.round;
    final name = raceName ?? race?.raceName ?? '';
    if (y == null || r == null) {
      return;
    }
    if (viewModel.draftQualifyingOrder.isEmpty || viewModel.draftRaceOrder.isEmpty) {
      return;
    }

    final previous = viewModel.store.weekend(year: y, round: r);
    final weekend = PredictorWeekendPrediction(
      round: r,
      raceName: name,
      qualifyingOrder: List<String>.from(viewModel.draftQualifyingOrder),
      raceOrder: List<String>.from(viewModel.draftRaceOrder),
      lockedAt: previous?.lockedAt,
      qualiPoints: previous?.qualiPoints,
      racePoints: previous?.racePoints,
      scoredAt: previous?.scoredAt,
      actualQualifyingOrder: previous?.actualQualifyingOrder,
      actualRaceOrder: previous?.actualRaceOrder,
    );
    final nextStore = await _predictorRepository!.saveWeekend(year: y, weekend: weekend);
    if (_disposed) {
      return;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(store: nextStore));
  }

  Future<void> _scoreAllPending() async {
    final viewModel = _holder.viewModel;
    final year = viewModel.seasonYear;
    if (year == null) {
      return;
    }
    final nextStore = await _scoringCoordinator.scoreAllPending(
      store: viewModel.store,
      year: year,
      now: viewModel.now,
    );
    if (nextStore == null) {
      return;
    }
    final replaced = await _predictorRepository!.replace(nextStore);
    if (_disposed) {
      return;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(store: replaced));
    await _syncLeaderboardPoints();
    if (_disposed) {
      return;
    }
    final race = _holder.viewModel.upcomingRace;
    if (race != null) {
      final current = _holder.viewModel.store.weekend(year: year, round: race.round);
      if (current != null && _holder.viewModel.isLocked) {
        _holder.setViewModel(
          _holder.viewModel.copyWith(
            draftQualifyingOrder: List<String>.from(current.qualifyingOrder),
            draftRaceOrder: List<String>.from(current.raceOrder),
          ),
        );
      }
    }
  }

  void _tickNow() {
    if (_disposed) {
      return;
    }
    final before = _holder.viewModel;
    final raceBefore = before.upcomingRace;
    final wasLocked = raceBefore == null || PredictorLock.isLocked(raceBefore, before.now);
    _holder.setViewModel(before.copyWith(now: DateTime.now()));
    final race = _holder.viewModel.upcomingRace;
    final nextKey = race == null ? null : '${race.season}_${race.round}';
    if (nextKey != _boundDraftKey) {
      unawaited(_ensureCurrentDraft());
    }
    if (race != null && !wasLocked && PredictorLock.isLocked(race, _holder.viewModel.now)) {
      unawaited(_onBecameLocked(race));
    }
  }

  Future<void> _onBecameLocked(RacesModel race) async {
    final viewModel = _holder.viewModel;
    final existing = viewModel.store.weekend(year: race.season, round: race.round);
    if (existing == null) {
      return;
    }
    final nextStore = await _predictorRepository!.saveWeekend(
      year: race.season,
      weekend: existing.copyWith(
        lockedAt: PredictorLock.lockAt(race) ?? viewModel.now,
        qualifyingOrder: List<String>.from(viewModel.draftQualifyingOrder),
        raceOrder: List<String>.from(viewModel.draftRaceOrder),
      ),
    );
    if (_disposed) {
      return;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(store: nextStore));
  }

  Future<void> _loadSchedule() async {
    await runAsyncLoad<ScheduleModel, List<RacesModel>>(
      fetch: _fetchSchedule,
      getField: () => _holder.viewModel.races,
      setField: (value) => _holder.setViewModel(_holder.viewModel.copyWith(races: value)),
      onSuccess: (data) => _holder.setViewModel(
        _holder.viewModel.copyWith(races: _holder.viewModel.races.toValue(data!.raceTable.races)),
      ),
    );
  }

  Future<void> _loadDriversList() async {
    await runAsyncLoad<List<DriverModel>, List<DriverModel>>(
      fetch: _loadDrivers,
      getField: () => _holder.viewModel.drivers,
      setField: (value) => _holder.setViewModel(_holder.viewModel.copyWith(drivers: value)),
      onSuccess: (data) => _holder.setViewModel(
        _holder.viewModel.copyWith(
          drivers: _holder.viewModel.drivers.toValue(data!.where(hasUsableDriverCode).toList()),
        ),
      ),
    );
  }

  /// Карта команд и порядок чемпионата из current driver standings
  /// (не блокирует UI при ошибке).
  Future<void> _loadConstructorsByDriver() async {
    if (_standingsRepository == null && _fetchDriverStandingsForTest == null) {
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          constructorsByDriverId: const {},
          championshipDriverOrder: const [],
        ),
      );
      return;
    }
    try {
      final standings = await _fetchDriverStandings();
      if (_disposed) {
        return;
      }
      final lists = standings.standingsTable.standingsLists;
      if (lists.isEmpty) {
        _holder.setViewModel(
          _holder.viewModel.copyWith(
            constructorsByDriverId: const {},
            championshipDriverOrder: const [],
          ),
        );
        return;
      }
      final rows = [...(lists.first.driverStandings ?? const <DriverStandingsModel>[])]
        ..sort((a, b) {
          final pa = int.tryParse(a.position) ?? 999;
          final pb = int.tryParse(b.position) ?? 999;
          return pa.compareTo(pb);
        });
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          constructorsByDriverId: {
            for (final row in rows)
              if (row.constructors.isNotEmpty) row.driver.driverId: row.constructors.first,
          },
          championshipDriverOrder: rows.map((row) => row.driver.driverId).toList(),
        ),
      );
    } on Object {
      if (_disposed) {
        return;
      }
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          constructorsByDriverId: const {},
          championshipDriverOrder: const [],
        ),
      );
    }
  }

  Future<ScheduleModel> _fetchSchedule() async {
    final forTest = _fetchScheduleForTest;
    if (forTest != null) {
      return forTest();
    }
    final result = await _scheduleRepository!.getSchedule();
    return result.schedule;
  }

  Future<List<DriverModel>> _loadDrivers() {
    final forTest = _loadDriversForTest;
    if (forTest != null) {
      return forTest();
    }
    return _driverCatalogRepository!.loadCurrent();
  }

  Future<StandingsModel> _fetchDriverStandings() async {
    final forTest = _fetchDriverStandingsForTest;
    if (forTest != null) {
      return forTest();
    }
    final repo = _standingsRepository;
    if (repo == null) {
      throw StateError('Provide standingsRepository or fetchDriverStandingsForTest');
    }
    return repo.drivers();
  }

  Future<void> _syncLeaderboardPoints() async {
    final year = _holder.viewModel.seasonYear;
    final repo = _leaderboardRepository;
    if (year == null || repo == null) {
      return;
    }
    await repo.syncPoints(year: year, totalPoints: _holder.viewModel.seasonTotalPoints);
  }
}
