import 'dart:async';

import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_season.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_season_summary.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_store.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_leaderboard_repository.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_repository.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_lock.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_lock_ticker.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_order.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_scoring_coordinator.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'package:f1_pet_project/core/predictor/services/predictor_order.dart'
    show PredictorGridKind, defaultPredictorOrder, hasUsableDriverCode;

/// Состояние экрана предиктора.
@immutable
class PredictorScreenState {
  PredictorScreenState({
    this.races = const Loadable.loading(),
    this.drivers = const Loadable.loading(),
    this.constructorsByDriverId = const {},
    this.championshipDriverOrder = const [],
    this.store = const PredictorStore(seasons: {}),
    this.predictions = const Loadable.loading(),
    DateTime? now,
    this.allDataIsLoaded = false,
    this.selectedGrid = PredictorGridKind.qualifying,
    this.draftQualifyingOrder = const [],
    this.draftRaceOrder = const [],
  }) : now = now ?? DateTime.now();

  final Loadable<List<RacesModel>> races;
  final Loadable<List<DriverModel>> drivers;

  /// Текущая команда пилота из driver standings (`driverId` → constructor).
  final Map<String, ConstructorModel> constructorsByDriverId;

  /// Порядок пилотов по текущему чемпионату (P1 → Pn).
  final List<String> championshipDriverOrder;

  final PredictorStore store;

  /// Загрузка / ошибка Firestore-store предиктов.
  final Loadable<PredictorStore> predictions;

  final DateTime now;
  final bool allDataIsLoaded;
  final PredictorGridKind selectedGrid;
  final List<String> draftQualifyingOrder;
  final List<String> draftRaceOrder;

  CustomException? get screenError => firstException([races, drivers, predictions]);

  String? get seasonYear {
    final list = races.value;
    if (list == null || list.isEmpty) {
      return null;
    }
    return list.first.season;
  }

  int get seasonTotalPoints {
    final year = seasonYear;
    if (year == null) {
      return 0;
    }
    return store.season(year)?.totalPoints ?? 0;
  }

  /// Ближайшая ещё не стартовавшая гонка.
  RacesModel? get upcomingRace {
    final list = races.value;
    if (list == null) {
      return null;
    }
    final upcoming = list.where((race) => RaceDateTimeHelper.isUpcoming(race, now)).toList()
      ..sort((a, b) => RaceDateTimeHelper.raceLocal(a).compareTo(RaceDateTimeHelper.raceLocal(b)));
    return upcoming.isEmpty ? null : upcoming.first;
  }

  DateTime? get lockAt {
    final race = upcomingRace;
    if (race == null) {
      return null;
    }
    return PredictorLock.lockAt(race);
  }

  bool get isLocked {
    final race = upcomingRace;
    if (race == null) {
      return true;
    }
    return PredictorLock.isLocked(race, now);
  }

  bool get missingQualifyingTime {
    final race = upcomingRace;
    return race != null && race.qualifying == null;
  }

  CountdownParts get lockCountdown {
    final at = lockAt;
    if (at == null) {
      return CountdownParts.zero;
    }
    return CountdownParts.until(at, now);
  }

  PredictorWeekendPrediction? get currentPrediction {
    final race = upcomingRace;
    final year = seasonYear;
    if (race == null || year == null) {
      return null;
    }
    return store.weekend(year: year, round: race.round);
  }

  /// История сезона без текущего upcoming (если он ещё не завершён).
  List<PredictorWeekendPrediction> get historyWeekends {
    final year = seasonYear;
    if (year == null) {
      return const [];
    }
    final season = store.season(year);
    if (season == null) {
      return const [];
    }
    final upcomingRound = upcomingRace?.round;
    return season.weekendsSorted.where((w) => w.round != upcomingRound).toList().reversed.toList();
  }

  /// Прошлые сезоны с предиктами (для кнопок под историей).
  List<PredictorSeasonSummary> get archivedSeasonSummaries {
    final current = seasonYear;
    final list = store.seasons.values
        .where((season) => season.year != current && season.weekends.isNotEmpty)
        .map(PredictorSeasonSummary.fromSeason)
        .toList()
      ..sort((a, b) => b.year.compareTo(a.year));
    return list;
  }

  Map<String, DriverModel> get driversById {
    final list = drivers.value ?? const <DriverModel>[];
    return {for (final d in list) d.driverId: d};
  }

  PredictorScreenState copyWith({
    Loadable<List<RacesModel>>? races,
    Loadable<List<DriverModel>>? drivers,
    Map<String, ConstructorModel>? constructorsByDriverId,
    List<String>? championshipDriverOrder,
    PredictorStore? store,
    Loadable<PredictorStore>? predictions,
    DateTime? now,
    bool? allDataIsLoaded,
    PredictorGridKind? selectedGrid,
    List<String>? draftQualifyingOrder,
    List<String>? draftRaceOrder,
  }) {
    return PredictorScreenState(
      races: races ?? this.races,
      drivers: drivers ?? this.drivers,
      constructorsByDriverId: constructorsByDriverId ?? this.constructorsByDriverId,
      championshipDriverOrder: championshipDriverOrder ?? this.championshipDriverOrder,
      store: store ?? this.store,
      predictions: predictions ?? this.predictions,
      now: now ?? this.now,
      allDataIsLoaded: allDataIsLoaded ?? this.allDataIsLoaded,
      selectedGrid: selectedGrid ?? this.selectedGrid,
      draftQualifyingOrder: draftQualifyingOrder ?? this.draftQualifyingOrder,
      draftRaceOrder: draftRaceOrder ?? this.draftRaceOrder,
    );
  }
}

/// Upcoming weekend, локальные предикты, lock и автоскоринг.
class PredictorScreenController extends Notifier<PredictorScreenState> {
  PredictorScreenController({
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
  }) : _predictorRepositoryForTest = predictorRepositoryForTest,
       _leaderboardRepositoryForTest = leaderboardRepositoryForTest,
       _fetchScheduleForTest = fetchScheduleForTest,
       _loadDriversForTest = loadDriversForTest,
       _fetchDriverStandingsForTest = fetchDriverStandingsForTest,
       _fetchQualifyingForTest = fetchQualifyingForTest,
       _fetchRaceResultsForTest = fetchRaceResultsForTest,
       _raceWeekendRepositoryForTest = raceWeekendRepositoryForTest;

  final PredictorRepository? _predictorRepositoryForTest;
  final PredictorLeaderboardRepository? _leaderboardRepositoryForTest;
  final Future<ScheduleModel> Function()? _fetchScheduleForTest;
  final Future<List<DriverModel>> Function()? _loadDriversForTest;
  final Future<StandingsModel> Function()? _fetchDriverStandingsForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchQualifyingForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchRaceResultsForTest;
  final RaceWeekendRepository? _raceWeekendRepositoryForTest;

  late final PredictorLockTicker _ticker;
  PredictorScoringCoordinator? _scoring;

  /// season+round текущего драфта — чтобы при смене upcomingRace перезагрузить порядок.
  String? _boundDraftKey;

  PredictorRepository get _predictorRepository =>
      _predictorRepositoryForTest ?? ref.read(predictorRepositoryProvider);

  PredictorLeaderboardRepository? get _leaderboardRepository =>
      _leaderboardRepositoryForTest ??
      (_predictorRepositoryForTest != null ? null : ref.read(predictorLeaderboardRepositoryProvider));

  ScheduleRepository? get _scheduleRepository {
    if (_fetchScheduleForTest != null) {
      return null;
    }
    return ref.read(scheduleRepositoryProvider);
  }

  CurrentStandingsRepository? get _standingsRepository {
    if (_fetchDriverStandingsForTest != null) {
      return null;
    }
    return ref.read(currentStandingsRepositoryProvider);
  }

  AppDataRefresh? get _dataRefresh {
    if (_predictorRepositoryForTest != null) {
      return null;
    }
    return ref.read(appDataRefreshProvider);
  }

  PredictorScoringCoordinator get _scoringCoordinator {
    return _scoring ??= PredictorScoringCoordinator(
      raceWeekendRepository: _raceWeekendRepositoryForTest ??
          (_predictorRepositoryForTest != null
              ? const RaceWeekendRepository()
              : ref.read(raceWeekendRepositoryProvider)),
      fetchQualifying: _fetchQualifyingForTest,
      fetchRaceResults: _fetchRaceResultsForTest,
    );
  }

  @override
  PredictorScreenState build() {
    _ticker = PredictorLockTicker(onTick: _tickNow);
    ref.onDispose(_ticker.dispose);
    return PredictorScreenState(now: DateTime.now());
  }

  PredictorSeason? seasonByYear(String year) => state.store.season(year);

  /// Первичная загрузка расписания, ростера, команд и store.
  Future<void> load() async {
    state = state.copyWith(allDataIsLoaded: false, predictions: const Loadable.loading());
    await Future.wait([_loadSchedule(), _loadDriversList(), _loadConstructorsByDriver()]);
    if (!ref.mounted) {
      return;
    }
    await _loadPredictionsStore();
    if (!ref.mounted) {
      return;
    }

    if (state.screenError == null) {
      await _ensureCurrentDraft();
      if (!ref.mounted) {
        return;
      }
      await _scoreAllPending();
      if (!ref.mounted) {
        return;
      }
      await _syncLeaderboardPoints();
      _ticker.start();
    }

    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(allDataIsLoaded: state.screenError == null);
  }

  Future<void> _loadPredictionsStore() async {
    try {
      final loaded = await _predictorRepository.load();
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(store: loaded, predictions: state.predictions.toValue(loaded));
    } on Object catch (e, st) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        predictions: state.predictions.toErrorFrom(
          CustomException(
            title: ErrorCopy.unexpectedError,
            subtitle: ErrorCopy.errorRetrySubtitle,
            parentException: e is Exception ? e : null,
            stackTrace: st,
          ),
        ),
      );
    }
  }

  /// Переключает вкладку квалификации / гонки.
  void selectGrid(PredictorGridKind kind) {
    state = state.copyWith(selectedGrid: kind);
  }

  /// Pull-to-refresh: сброс API-кэшей, предикты не трогаем.
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    if (!ref.mounted) {
      return;
    }
    await load();
  }

  /// Drag-reorder: remove + insert (сдвигает соседей). Для точечной смены места — [moveDraftTo].
  Future<void> reorderDraft({required int oldIndex, required int newIndex}) async {
    if (state.isLocked || oldIndex == newIndex) {
      return;
    }
    final list = List<String>.from(
      state.selectedGrid == PredictorGridKind.qualifying ? state.draftQualifyingOrder : state.draftRaceOrder,
    );
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    state = state.selectedGrid == PredictorGridKind.qualifying
        ? state.copyWith(draftQualifyingOrder: list)
        : state.copyWith(draftRaceOrder: list);
    await _persistDraft();
  }

  /// Меняет местами пилотов на [fromIndex] и [toIndex] (0 = P1).
  /// Остальные позиции не сдвигаются.
  Future<void> moveDraftTo({required int fromIndex, required int toIndex}) async {
    if (state.isLocked || fromIndex == toIndex) {
      return;
    }
    final list = List<String>.from(
      state.selectedGrid == PredictorGridKind.qualifying ? state.draftQualifyingOrder : state.draftRaceOrder,
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
    state = state.selectedGrid == PredictorGridKind.qualifying
        ? state.copyWith(draftQualifyingOrder: list)
        : state.copyWith(draftRaceOrder: list);
    await _persistDraft();
  }

  /// Копирует текущий предикт квалификации в гонку.
  Future<void> copyQualifyingToRace() async {
    if (state.isLocked || state.draftQualifyingOrder.isEmpty) {
      return;
    }
    state = state.copyWith(draftRaceOrder: List<String>.from(state.draftQualifyingOrder));
    await _persistDraft();
  }

  Future<void> _ensureCurrentDraft() async {
    final race = state.upcomingRace;
    final roster = state.drivers.value;
    if (race == null || roster == null || roster.isEmpty) {
      state = state.copyWith(draftQualifyingOrder: const [], draftRaceOrder: const []);
      _boundDraftKey = null;
      return;
    }

    final year = race.season;
    final existing = state.store.weekend(year: year, round: race.round);
    final rosterIds = roster.map((d) => d.driverId).toList();
    _boundDraftKey = '${race.season}_${race.round}';

    if (existing == null) {
      final initial = defaultPredictorOrder(
        rosterIds: rosterIds,
        championshipOrder: state.championshipDriverOrder,
      );
      state = state.copyWith(
        draftQualifyingOrder: List<String>.from(initial),
        draftRaceOrder: List<String>.from(initial),
      );
      await _persistDraft(raceName: race.raceName, round: race.round, year: year);
      return;
    }

    if (PredictorLock.isLocked(race, state.now)) {
      state = state.copyWith(
        draftQualifyingOrder: List<String>.from(existing.qualifyingOrder),
        draftRaceOrder: List<String>.from(existing.raceOrder),
      );
      if (existing.lockedAt == null) {
        await _predictorRepository.saveWeekend(
          year: year,
          weekend: existing.copyWith(lockedAt: PredictorLock.lockAt(race) ?? state.now),
        );
        if (!ref.mounted) {
          return;
        }
        state = state.copyWith(store: await _predictorRepository.load());
      }
      return;
    }

    state = state.copyWith(
      draftQualifyingOrder: syncOrderToRoster(existing.qualifyingOrder, rosterIds),
      draftRaceOrder: syncOrderToRoster(existing.raceOrder, rosterIds),
    );
    await _persistDraft(raceName: race.raceName, round: race.round, year: year);
  }

  Future<void> _persistDraft({String? raceName, String? round, String? year}) async {
    final race = state.upcomingRace;
    final y = year ?? race?.season;
    final r = round ?? race?.round;
    final name = raceName ?? race?.raceName ?? '';
    if (y == null || r == null) {
      return;
    }
    if (state.draftQualifyingOrder.isEmpty || state.draftRaceOrder.isEmpty) {
      return;
    }

    final previous = state.store.weekend(year: y, round: r);
    final weekend = PredictorWeekendPrediction(
      round: r,
      raceName: name,
      qualifyingOrder: List<String>.from(state.draftQualifyingOrder),
      raceOrder: List<String>.from(state.draftRaceOrder),
      lockedAt: previous?.lockedAt,
      qualiPoints: previous?.qualiPoints,
      racePoints: previous?.racePoints,
      scoredAt: previous?.scoredAt,
      actualQualifyingOrder: previous?.actualQualifyingOrder,
      actualRaceOrder: previous?.actualRaceOrder,
    );
    final nextStore = await _predictorRepository.saveWeekend(year: y, weekend: weekend);
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(store: nextStore);
  }

  Future<void> _scoreAllPending() async {
    final year = state.seasonYear;
    if (year == null) {
      return;
    }
    final nextStore = await _scoringCoordinator.scoreAllPending(store: state.store, year: year, now: state.now);
    if (nextStore == null) {
      return;
    }
    final replaced = await _predictorRepository.replace(nextStore);
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(store: replaced);
    await _syncLeaderboardPoints();
    if (!ref.mounted) {
      return;
    }
    final race = state.upcomingRace;
    if (race != null) {
      final current = state.store.weekend(year: year, round: race.round);
      if (current != null && state.isLocked) {
        state = state.copyWith(
          draftQualifyingOrder: List<String>.from(current.qualifyingOrder),
          draftRaceOrder: List<String>.from(current.raceOrder),
        );
      }
    }
  }

  void _tickNow() {
    if (!ref.mounted) {
      return;
    }
    final raceBefore = state.upcomingRace;
    final wasLocked = raceBefore == null || PredictorLock.isLocked(raceBefore, state.now);
    state = state.copyWith(now: DateTime.now());
    final race = state.upcomingRace;
    final nextKey = race == null ? null : '${race.season}_${race.round}';
    if (nextKey != _boundDraftKey) {
      unawaited(_ensureCurrentDraft());
    }
    if (race != null && !wasLocked && PredictorLock.isLocked(race, state.now)) {
      unawaited(_onBecameLocked(race));
    }
  }

  Future<void> _onBecameLocked(RacesModel race) async {
    final existing = state.store.weekend(year: race.season, round: race.round);
    if (existing == null) {
      return;
    }
    final nextStore = await _predictorRepository.saveWeekend(
      year: race.season,
      weekend: existing.copyWith(
        lockedAt: PredictorLock.lockAt(race) ?? state.now,
        qualifyingOrder: List<String>.from(state.draftQualifyingOrder),
        raceOrder: List<String>.from(state.draftRaceOrder),
      ),
    );
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(store: nextStore);
  }

  Future<void> _loadSchedule() async {
    await runAsyncLoad<ScheduleModel, List<RacesModel>>(
      fetch: _fetchSchedule,
      getField: () => state.races,
      setField: (value) => state = state.copyWith(races: value),
      onSuccess: (data) => state = state.copyWith(races: state.races.toValue(data!.raceTable.races)),
    );
  }

  Future<void> _loadDriversList() async {
    await runAsyncLoad<List<DriverModel>, List<DriverModel>>(
      fetch: _loadDrivers,
      getField: () => state.drivers,
      setField: (value) => state = state.copyWith(drivers: value),
      onSuccess: (data) => state = state.copyWith(drivers: state.drivers.toValue(data!.where(hasUsableDriverCode).toList())),
    );
  }

  /// Карта команд и порядок чемпионата из current driver standings
  /// (не блокирует UI при ошибке).
  Future<void> _loadConstructorsByDriver() async {
    if (_standingsRepository == null && _fetchDriverStandingsForTest == null) {
      state = state.copyWith(constructorsByDriverId: const {}, championshipDriverOrder: const []);
      return;
    }
    try {
      final standings = await _fetchDriverStandings();
      if (!ref.mounted) {
        return;
      }
      final lists = standings.standingsTable.standingsLists;
      if (lists.isEmpty) {
        state = state.copyWith(constructorsByDriverId: const {}, championshipDriverOrder: const []);
        return;
      }
      final rows = [...(lists.first.driverStandings ?? const <DriverStandingsModel>[])]
        ..sort((a, b) {
          final pa = int.tryParse(a.position) ?? 999;
          final pb = int.tryParse(b.position) ?? 999;
          return pa.compareTo(pb);
        });
      state = state.copyWith(
        constructorsByDriverId: {
          for (final row in rows)
            if (row.constructors.isNotEmpty) row.driver.driverId: row.constructors.first,
        },
        championshipDriverOrder: rows.map((row) => row.driver.driverId).toList(),
      );
    } on Object {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(constructorsByDriverId: const {}, championshipDriverOrder: const []);
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
    return ref.read(driverCatalogRepositoryProvider).loadCurrent();
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
    final year = state.seasonYear;
    final repo = _leaderboardRepository;
    if (year == null || repo == null) {
      return;
    }
    await repo.syncPoints(year: year, totalPoints: state.seasonTotalPoints);
  }
}

final predictorScreenControllerProvider =
    NotifierProvider.autoDispose<PredictorScreenController, PredictorScreenState>(PredictorScreenController.new);
