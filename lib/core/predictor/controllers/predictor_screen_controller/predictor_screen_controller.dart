import 'dart:async';

import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/network_reachability.dart';
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
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
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
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

export 'package:f1_pet_project/core/predictor/services/predictor_order.dart'
    show PredictorGridKind, defaultPredictorOrder, hasUsableDriverCode;

part 'predictor_screen_controller.g.dart';

/// MobX-контроллер экрана предиктора.
class PredictorScreenController = PredictorScreenControllerBase with _$PredictorScreenController;

/// Upcoming weekend, локальные предикты, lock и автоскоринг.
abstract class PredictorScreenControllerBase with Store {
  PredictorScreenControllerBase({
    required PredictorRepository predictorRepository,
    PredictorLeaderboardRepository? leaderboardRepository,
    ScheduleRepository? scheduleRepository,
    DriverCatalogRepository? driverCatalogRepository,
    CurrentStandingsRepository? standingsRepository,
    RaceWeekendRepository? raceWeekendRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<ScheduleModel> Function()? fetchScheduleForTest,
    @visibleForTesting Future<List<DriverModel>> Function()? loadDriversForTest,
    @visibleForTesting Future<StandingsModel> Function()? fetchDriverStandingsForTest,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchQualifyingForTest,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchRaceResultsForTest,
  }) : assert(
         scheduleRepository != null || fetchScheduleForTest != null,
         'Provide scheduleRepository or fetchScheduleForTest',
       ),
       assert(
         driverCatalogRepository != null || loadDriversForTest != null,
         'Provide driverCatalogRepository or loadDriversForTest',
       ),
       _predictorRepository = predictorRepository,
       _leaderboardRepository = leaderboardRepository,
       _scheduleRepository = scheduleRepository,
       _standingsRepository = standingsRepository,
       _dataRefresh = dataRefresh,
       _fetchScheduleForTest = fetchScheduleForTest,
       _loadDrivers = loadDriversForTest ?? driverCatalogRepository!.loadCurrent,
       _fetchDriverStandingsForTest = fetchDriverStandingsForTest,
       _scoring = PredictorScoringCoordinator(
         raceWeekendRepository: raceWeekendRepository ?? const RaceWeekendRepository(),
         fetchQualifying: fetchQualifyingForTest,
         fetchRaceResults: fetchRaceResultsForTest,
       ) {
    _ticker = PredictorLockTicker(onTick: _tickNow);
  }

  final PredictorRepository _predictorRepository;
  final PredictorLeaderboardRepository? _leaderboardRepository;
  final ScheduleRepository? _scheduleRepository;
  final CurrentStandingsRepository? _standingsRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<ScheduleModel> Function()? _fetchScheduleForTest;
  final Future<List<DriverModel>> Function() _loadDrivers;
  final Future<StandingsModel> Function()? _fetchDriverStandingsForTest;
  final PredictorScoringCoordinator _scoring;

  /// Жёсткий потолок ожидания сети/Firestore, чтобы UI не завис на лоадере.
  static const _predictorLoadTimeout = Duration(seconds: 40);

  late final PredictorLockTicker _ticker;

  /// Поколение [load]: после таймаута инкремент, чтобы фоновый `runAsyncLoad` не вернул loading.
  int _loadEpoch = 0;

  /// season+round текущего драфта — чтобы при смене upcomingRace перезагрузить порядок.
  String? _boundDraftKey;

  bool _isLoadEpoch(int epoch) => epoch == _loadEpoch;

  @observable
  AsyncValue<List<RacesModel>> races = const AsyncValue.loading();

  @observable
  AsyncValue<List<DriverModel>> drivers = const AsyncValue.loading();

  /// Текущая команда пилота из driver standings (`driverId` → constructor).
  @observable
  ObservableMap<String, ConstructorModel> constructorsByDriverId = ObservableMap();

  /// Порядок пилотов по текущему чемпионату (P1 → Pn).
  @observable
  ObservableList<String> championshipDriverOrder = ObservableList<String>();

  @observable
  PredictorStore store = PredictorStore.empty();

  /// Загрузка / ошибка Firestore-store предиктов.
  @observable
  AsyncValue<PredictorStore> predictions = const AsyncValue.loading();

  @observable
  DateTime now = DateTime.now();

  @observable
  bool allDataIsLoaded = false;

  @observable
  PredictorGridKind selectedGrid = PredictorGridKind.qualifying;

  @observable
  ObservableList<String> draftQualifyingOrder = ObservableList<String>();

  @observable
  ObservableList<String> draftRaceOrder = ObservableList<String>();

  @computed
  CustomException? get screenError => firstException([races, drivers, predictions]);

  @computed
  String? get seasonYear {
    final list = races.value;
    if (list == null || list.isEmpty) {
      return null;
    }
    return list.first.season;
  }

  @computed
  int get seasonTotalPoints {
    final year = seasonYear;
    if (year == null) {
      return 0;
    }
    return store.season(year)?.totalPoints ?? 0;
  }

  /// Ближайшая ещё не стартовавшая гонка.
  @computed
  RacesModel? get upcomingRace {
    final list = races.value;
    if (list == null) {
      return null;
    }
    final upcoming = list.where((race) => RaceDateTimeHelper.isUpcoming(race, now)).toList()
      ..sort((a, b) => RaceDateTimeHelper.raceLocal(a).compareTo(RaceDateTimeHelper.raceLocal(b)));
    return upcoming.isEmpty ? null : upcoming.first;
  }

  @computed
  DateTime? get lockAt {
    final race = upcomingRace;
    if (race == null) {
      return null;
    }
    return PredictorLock.lockAt(race);
  }

  @computed
  bool get isLocked {
    final race = upcomingRace;
    if (race == null) {
      return true;
    }
    return PredictorLock.isLocked(race, now);
  }

  @computed
  bool get missingQualifyingTime {
    final race = upcomingRace;
    return race != null && race.qualifying == null;
  }

  @computed
  CountdownParts get lockCountdown {
    final at = lockAt;
    if (at == null) {
      return CountdownParts.zero;
    }
    return CountdownParts.until(at, now);
  }

  @computed
  PredictorWeekendPrediction? get currentPrediction {
    final race = upcomingRace;
    final year = seasonYear;
    if (race == null || year == null) {
      return null;
    }
    return store.weekend(year: year, round: race.round);
  }

  /// История сезона без текущего upcoming (если он ещё не завершён).
  @computed
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
  @computed
  List<PredictorSeasonSummary> get archivedSeasonSummaries {
    final current = seasonYear;
    final list = store.seasons.values
        .where((season) => season.year != current && season.weekends.isNotEmpty)
        .map(PredictorSeasonSummary.fromSeason)
        .toList()
      ..sort((a, b) => b.year.compareTo(a.year));
    return list;
  }

  PredictorSeason? seasonByYear(String year) => store.season(year);

  Map<String, DriverModel> get driversById {
    final list = drivers.value ?? const <DriverModel>[];
    return {for (final d in list) d.driverId: d};
  }

  /// Освобождает ticker.
  void dispose() {
    _ticker.dispose();
  }

  /// Первичная загрузка расписания, ростера, команд и store.
  @action
  Future<void> load() async {
    final epoch = ++_loadEpoch;
    allDataIsLoaded = false;
    predictions = const AsyncValue.loading();

    if (await NetworkReachability.isOffline()) {
      if (!_isLoadEpoch(epoch)) {
        return;
      }
      _applyNoConnection();
      allDataIsLoaded = false;
      return;
    }

    try {
      await _loadBody(epoch).timeout(_predictorLoadTimeout);
    } on TimeoutException catch (e, st) {
      if (!_isLoadEpoch(epoch)) {
        return;
      }
      final hasCore = races.value != null && drivers.value != null && predictions.value != null;
      if (!hasCore) {
        _applyPredictorTimeout(e, st);
      }
      // Отсекаем поздние setField(toLoading) от незавершённых retry.
      _loadEpoch++;
      allDataIsLoaded = hasCore && screenError == null;
      if (allDataIsLoaded) {
        _ticker.start();
      }
      return;
    }

    if (!_isLoadEpoch(epoch)) {
      return;
    }
    // Нет сети — сразу ErrorBody, без ожидания остальных запросов.
    if (_isNoConnection(screenError)) {
      _loadEpoch++;
      allDataIsLoaded = false;
      return;
    }
    allDataIsLoaded = screenError == null;
    if (allDataIsLoaded) {
      _ticker.start();
    }
  }

  Future<void> _loadBody(int epoch) async {
    await Future.wait([
      _loadSchedule(epoch),
      _loadDriversList(epoch),
      _loadConstructorsByDriver(epoch),
    ]);
    if (!_isLoadEpoch(epoch)) {
      return;
    }
    if (_isNoConnection(screenError)) {
      return;
    }
    await _loadPredictionsStore(epoch);
    if (!_isLoadEpoch(epoch) || screenError != null) {
      return;
    }
    await _ensureCurrentDraft();
    if (!_isLoadEpoch(epoch)) {
      return;
    }
    await _scoreAllPending();
    if (!_isLoadEpoch(epoch)) {
      return;
    }
    try {
      await _syncLeaderboardPoints();
    } on Object {
      // Лидерборд не должен валить экран.
    }
  }

  bool _isNoConnection(CustomException? error) => error?.title == ErrorCopy.noConnection;

  void _applyNoConnection([Object? parent, StackTrace? st]) {
    final exception = CustomException(
      title: ErrorCopy.noConnection,
      subtitle: ErrorCopy.noConnectionSubtitle,
      parentException: parent is Exception ? parent : null,
      stackTrace: st,
    );
    if (races.exception == null && races.value == null) {
      races = races.toErrorFrom(exception);
    }
    if (drivers.exception == null && drivers.value == null) {
      drivers = drivers.toErrorFrom(exception);
    }
    if (predictions.exception == null && predictions.value == null) {
      predictions = predictions.toErrorFrom(exception);
    }
  }

  void _applyPredictorTimeout(TimeoutException e, StackTrace st) {
    _applyNoConnection(e, st);
  }

  @action
  Future<void> _loadPredictionsStore(int epoch) async {
    try {
      final loaded = await _predictorRepository.load();
      if (!_isLoadEpoch(epoch)) {
        return;
      }
      store = loaded;
      predictions = predictions.toValue(loaded);
    } on TimeoutException catch (e, st) {
      if (!_isLoadEpoch(epoch)) {
        return;
      }
      predictions = predictions.toErrorFrom(
        CustomException(
          title: ErrorCopy.noConnection,
          subtitle: ErrorCopy.noConnectionSubtitle,
          parentException: e,
          stackTrace: st,
        ),
      );
    } on Object catch (e, st) {
      if (!_isLoadEpoch(epoch)) {
        return;
      }
      predictions = predictions.toErrorFrom(
        CustomException(
          title: ErrorCopy.unexpectedError,
          subtitle: ErrorCopy.errorRetrySubtitle,
          parentException: e is Exception ? e : null,
          stackTrace: st,
        ),
      );
    }
  }

  /// Переключает вкладку квалификации / гонки.
  @action
  void selectGrid(PredictorGridKind kind) {
    selectedGrid = kind;
  }

  /// Pull-to-refresh: сброс API-кэшей, предикты не трогаем.
  @action
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await load();
  }

  /// Drag-reorder: remove + insert (сдвигает соседей). Для точечной смены места — [moveDraftTo].
  @action
  Future<void> reorderDraft({required int oldIndex, required int newIndex}) async {
    if (isLocked || oldIndex == newIndex) {
      return;
    }
    final list = selectedGrid == PredictorGridKind.qualifying ? draftQualifyingOrder : draftRaceOrder;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    await _persistDraft();
  }

  /// Меняет местами пилотов на [fromIndex] и [toIndex] (0 = P1).
  /// Остальные позиции не сдвигаются.
  @action
  Future<void> moveDraftTo({required int fromIndex, required int toIndex}) async {
    if (isLocked || fromIndex == toIndex) {
      return;
    }
    final list = selectedGrid == PredictorGridKind.qualifying ? draftQualifyingOrder : draftRaceOrder;
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
    await _persistDraft();
  }

  /// Копирует текущий предикт квалификации в гонку.
  @action
  Future<void> copyQualifyingToRace() async {
    if (isLocked || draftQualifyingOrder.isEmpty) {
      return;
    }
    draftRaceOrder
      ..clear()
      ..addAll(draftQualifyingOrder);
    await _persistDraft();
  }

  @action
  Future<void> _ensureCurrentDraft() async {
    final race = upcomingRace;
    final roster = drivers.value;
    if (race == null || roster == null || roster.isEmpty) {
      draftQualifyingOrder.clear();
      draftRaceOrder.clear();
      _boundDraftKey = null;
      return;
    }

    final year = race.season;
    final existing = store.weekend(year: year, round: race.round);
    final rosterIds = roster.map((d) => d.driverId).toList();
    _boundDraftKey = '${race.season}_${race.round}';

    if (existing == null) {
      final initial = defaultPredictorOrder(
        rosterIds: rosterIds,
        championshipOrder: championshipDriverOrder,
      );
      draftQualifyingOrder
        ..clear()
        ..addAll(initial);
      draftRaceOrder
        ..clear()
        ..addAll(initial);
      await _persistDraft(raceName: race.raceName, round: race.round, year: year);
      return;
    }

    if (PredictorLock.isLocked(race, now)) {
      draftQualifyingOrder
        ..clear()
        ..addAll(existing.qualifyingOrder);
      draftRaceOrder
        ..clear()
        ..addAll(existing.raceOrder);
      if (existing.lockedAt == null) {
        await _predictorRepository.saveWeekend(
          year: year,
          weekend: existing.copyWith(lockedAt: PredictorLock.lockAt(race) ?? now),
        );
        store = await _predictorRepository.load();
      }
      return;
    }

    draftQualifyingOrder
      ..clear()
      ..addAll(syncOrderToRoster(existing.qualifyingOrder, rosterIds));
    draftRaceOrder
      ..clear()
      ..addAll(syncOrderToRoster(existing.raceOrder, rosterIds));
    await _persistDraft(raceName: race.raceName, round: race.round, year: year);
  }

  Future<void> _persistDraft({String? raceName, String? round, String? year}) async {
    final race = upcomingRace;
    final y = year ?? race?.season;
    final r = round ?? race?.round;
    final name = raceName ?? race?.raceName ?? '';
    if (y == null || r == null) {
      return;
    }
    if (draftQualifyingOrder.isEmpty || draftRaceOrder.isEmpty) {
      return;
    }

    final previous = store.weekend(year: y, round: r);
    final weekend = PredictorWeekendPrediction(
      round: r,
      raceName: name,
      qualifyingOrder: List<String>.from(draftQualifyingOrder),
      raceOrder: List<String>.from(draftRaceOrder),
      lockedAt: previous?.lockedAt,
      qualiPoints: previous?.qualiPoints,
      racePoints: previous?.racePoints,
      scoredAt: previous?.scoredAt,
      actualQualifyingOrder: previous?.actualQualifyingOrder,
      actualRaceOrder: previous?.actualRaceOrder,
    );
    store = await _predictorRepository.saveWeekend(year: y, weekend: weekend);
  }

  @action
  Future<void> _scoreAllPending() async {
    final year = seasonYear;
    if (year == null) {
      return;
    }
    final nextStore = await _scoring.scoreAllPending(store: store, year: year, now: now);
    if (nextStore == null) {
      return;
    }
    store = await _predictorRepository.replace(nextStore);
    await _syncLeaderboardPoints();
    final race = upcomingRace;
    if (race != null) {
      final current = store.weekend(year: year, round: race.round);
      if (current != null && isLocked) {
        draftQualifyingOrder
          ..clear()
          ..addAll(current.qualifyingOrder);
        draftRaceOrder
          ..clear()
          ..addAll(current.raceOrder);
      }
    }
  }

  @action
  void _tickNow() {
    final raceBefore = upcomingRace;
    final wasLocked = raceBefore == null || PredictorLock.isLocked(raceBefore, now);
    now = DateTime.now();
    final race = upcomingRace;
    final nextKey = race == null ? null : '${race.season}_${race.round}';
    if (nextKey != _boundDraftKey) {
      unawaited(_ensureCurrentDraft());
    }
    if (race != null && !wasLocked && PredictorLock.isLocked(race, now)) {
      unawaited(_onBecameLocked(race));
    }
  }

  @action
  Future<void> _onBecameLocked(RacesModel race) async {
    final existing = store.weekend(year: race.season, round: race.round);
    if (existing == null) {
      return;
    }
    store = await _predictorRepository.saveWeekend(
      year: race.season,
      weekend: existing.copyWith(
        lockedAt: PredictorLock.lockAt(race) ?? now,
        qualifyingOrder: List<String>.from(draftQualifyingOrder),
        raceOrder: List<String>.from(draftRaceOrder),
      ),
    );
  }

  @action
  Future<void> _loadSchedule(int epoch) async {
    await runAsyncLoad<ScheduleModel, List<RacesModel>>(
      fetch: _fetchSchedule,
      getField: () => races,
      setField: (value) {
        if (!_isLoadEpoch(epoch)) {
          return;
        }
        races = value;
      },
      onSuccess: (data) {
        if (!_isLoadEpoch(epoch)) {
          return;
        }
        races = races.toValue(data!.raceTable.races);
      },
    );
  }

  @action
  Future<void> _loadDriversList(int epoch) async {
    await runAsyncLoad<List<DriverModel>, List<DriverModel>>(
      fetch: _loadDrivers,
      getField: () => drivers,
      setField: (value) {
        if (!_isLoadEpoch(epoch)) {
          return;
        }
        drivers = value;
      },
      onSuccess: (data) {
        if (!_isLoadEpoch(epoch)) {
          return;
        }
        drivers = drivers.toValue(data!.where(hasUsableDriverCode).toList());
      },
    );
  }

  /// Карта команд и порядок чемпионата из current driver standings
  /// (не блокирует UI при ошибке).
  @action
  Future<void> _loadConstructorsByDriver(int epoch) async {
    if (_standingsRepository == null && _fetchDriverStandingsForTest == null) {
      if (_isLoadEpoch(epoch)) {
        constructorsByDriverId = ObservableMap();
        championshipDriverOrder = ObservableList();
      }
      return;
    }
    try {
      final standings = await _fetchDriverStandings();
      if (!_isLoadEpoch(epoch)) {
        return;
      }
      final lists = standings.standingsTable.standingsLists;
      if (lists.isEmpty) {
        constructorsByDriverId = ObservableMap();
        championshipDriverOrder = ObservableList();
        return;
      }
      final rows = [...(lists.first.driverStandings ?? const <DriverStandingsModel>[])]
        ..sort((a, b) {
          final pa = int.tryParse(a.position) ?? 999;
          final pb = int.tryParse(b.position) ?? 999;
          return pa.compareTo(pb);
        });
      constructorsByDriverId = ObservableMap.of({
        for (final row in rows)
          if (row.constructors.isNotEmpty) row.driver.driverId: row.constructors.first,
      });
      championshipDriverOrder = ObservableList.of(rows.map((row) => row.driver.driverId));
    } on Object {
      if (!_isLoadEpoch(epoch)) {
        return;
      }
      constructorsByDriverId = ObservableMap();
      championshipDriverOrder = ObservableList();
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
    final year = seasonYear;
    final repo = _leaderboardRepository;
    if (year == null || repo == null) {
      return;
    }
    await repo.syncPoints(year: year, totalPoints: seasonTotalPoints);
  }
}
