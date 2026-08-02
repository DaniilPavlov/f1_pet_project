import 'dart:async';

import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_season.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_season_summary.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_store.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_repository.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_lock.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_score_service.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'predictor_screen_controller.g.dart';

/// Пилот с реальным трёхбуквенным кодом (не пустой и не `none`).
bool hasUsableDriverCode(DriverModel driver) {
  final code = driver.code?.trim();
  return code != null && code.isNotEmpty && code.toLowerCase() != 'none';
}

/// Какая сетка сейчас редактируется.
enum PredictorGridKind { qualifying, race }

/// MobX-контроллер экрана предиктора.
class PredictorScreenController = PredictorScreenControllerBase with _$PredictorScreenController;

/// Upcoming weekend, локальные предикты, lock и автоскоринг.
abstract class PredictorScreenControllerBase with Store {
  PredictorScreenControllerBase({
    required PredictorRepository predictorRepository,
    ScheduleRepository? scheduleRepository,
    DriverCatalogRepository? driverCatalogRepository,
    RaceWeekendRepository? raceWeekendRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<ScheduleModel> Function()? fetchScheduleForTest,
    @visibleForTesting Future<List<DriverModel>> Function()? loadDriversForTest,
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
       _scheduleRepository = scheduleRepository,
       _raceWeekendRepository = raceWeekendRepository ?? const RaceWeekendRepository(),
       _dataRefresh = dataRefresh,
       _fetchScheduleForTest = fetchScheduleForTest,
       _loadDrivers = loadDriversForTest ?? driverCatalogRepository!.loadCurrent,
       _fetchQualifyingForTest = fetchQualifyingForTest,
       _fetchRaceResultsForTest = fetchRaceResultsForTest;

  final PredictorRepository _predictorRepository;
  final ScheduleRepository? _scheduleRepository;
  final RaceWeekendRepository _raceWeekendRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<ScheduleModel> Function()? _fetchScheduleForTest;
  final Future<List<DriverModel>> Function() _loadDrivers;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchQualifyingForTest;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchRaceResultsForTest;

  Timer? _ticker;

  @observable
  AsyncValue<List<RacesModel>> races = const AsyncValue.loading();

  @observable
  AsyncValue<List<DriverModel>> drivers = const AsyncValue.loading();

  @observable
  PredictorStore store = PredictorStore.empty();

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
  CustomException? get screenError => firstException([races, drivers]);

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
    _ticker?.cancel();
    _ticker = null;
  }

  /// Первичная загрузка расписания, ростера и локального store.
  @action
  Future<void> load() async {
    allDataIsLoaded = false;
    await Future.wait([_loadSchedule(), _loadDriversList()]);
    store = await _predictorRepository.load();

    if (screenError == null) {
      await _ensureCurrentDraft();
      await _scoreAllPending();
      _startTicker();
    }

    allDataIsLoaded = screenError == null;
  }

  /// Pull-to-refresh: сброс API-кэшей, предикты не трогаем.
  @action
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await load();
  }

  @action
  void selectGrid(PredictorGridKind kind) {
    selectedGrid = kind;
  }

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

  @action
  Future<void> _ensureCurrentDraft() async {
    final race = upcomingRace;
    final roster = drivers.value;
    if (race == null || roster == null || roster.isEmpty) {
      draftQualifyingOrder.clear();
      draftRaceOrder.clear();
      return;
    }

    final year = race.season;
    final existing = store.weekend(year: year, round: race.round);
    final rosterIds = roster.map((d) => d.driverId).toList();

    if (existing == null) {
      draftQualifyingOrder
        ..clear()
        ..addAll(rosterIds);
      draftRaceOrder
        ..clear()
        ..addAll(rosterIds);
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
      ..addAll(_syncOrderToRoster(existing.qualifyingOrder, rosterIds));
    draftRaceOrder
      ..clear()
      ..addAll(_syncOrderToRoster(existing.raceOrder, rosterIds));
    await _persistDraft(raceName: race.raceName, round: race.round, year: year);
  }

  List<String> _syncOrderToRoster(List<String> saved, List<String> rosterIds) {
    final rosterSet = rosterIds.toSet();
    final kept = saved.where(rosterSet.contains).toList();
    final missing = rosterIds.where((id) => !kept.contains(id));
    return [...kept, ...missing];
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
    );
    store = await _predictorRepository.saveWeekend(year: y, weekend: weekend);
  }

  @action
  Future<void> _scoreAllPending() async {
    final year = seasonYear;
    if (year == null) {
      return;
    }
    final season = store.season(year);
    if (season == null || season.weekends.isEmpty) {
      return;
    }

    var nextStore = store;
    var changed = false;
    for (final weekend in season.weekends.values) {
      final scored = await _scoreWeekend(year: year, weekend: weekend);
      if (scored != null &&
          (scored.qualiPoints != weekend.qualiPoints || scored.racePoints != weekend.racePoints)) {
        nextStore = nextStore.upsertWeekend(year: year, weekend: scored);
        changed = true;
      }
    }
    if (changed) {
      store = await _predictorRepository.replace(nextStore);
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
  }

  Future<PredictorWeekendPrediction?> _scoreWeekend({
    required String year,
    required PredictorWeekendPrediction weekend,
  }) async {
    if (weekend.qualifyingOrder.isEmpty && weekend.raceOrder.isEmpty) {
      return null;
    }

    List<QualifyingResultsModel>? qualiList;
    List<ResultsModel>? raceList;

    try {
      final qualiModel = await _fetchQualifying(year: year, round: weekend.round);
      qualiList = qualiModel.raceTable.races.isEmpty
          ? null
          : qualiModel.raceTable.races.first.qualifyingResults;
    } on Object {
      qualiList = null;
    }

    try {
      final raceModel = await _fetchRaceResults(year: year, round: weekend.round);
      raceList = raceModel.raceTable.races.isEmpty ? null : raceModel.raceTable.races.first.results;
    } on Object {
      raceList = null;
    }

    if ((qualiList == null || qualiList.isEmpty) && (raceList == null || raceList.isEmpty)) {
      return null;
    }

    return PredictorScoreService.applyResults(
      weekend: weekend,
      qualifyingResults: qualiList,
      raceResults: raceList,
      now: now,
    );
  }

  void _startTicker() {
    _ticker?.cancel();
    _tickNow();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tickNow());
  }

  @action
  void _tickNow() {
    final raceBefore = upcomingRace;
    final wasLocked = raceBefore == null || PredictorLock.isLocked(raceBefore, now);
    now = DateTime.now();
    final race = upcomingRace;
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
  Future<void> _loadSchedule() async {
    await runAsyncLoad<ScheduleModel, List<RacesModel>>(
      fetch: _fetchSchedule,
      getField: () => races,
      setField: (value) => races = value,
      onSuccess: (data) => races = races.toValue(data!.raceTable.races),
    );
  }

  @action
  Future<void> _loadDriversList() async {
    await runAsyncLoad<List<DriverModel>, List<DriverModel>>(
      fetch: _loadDrivers,
      getField: () => drivers,
      setField: (value) => drivers = value,
      onSuccess: (data) => drivers = drivers.toValue(_withDriverCode(data!)),
    );
  }

  /// Только пилоты с реальным трёхбуквенным кодом (без `none`).
  static List<DriverModel> _withDriverCode(List<DriverModel> list) {
    return list.where(hasUsableDriverCode).toList();
  }

  Future<ScheduleModel> _fetchSchedule() async {
    final forTest = _fetchScheduleForTest;
    if (forTest != null) {
      return forTest();
    }
    final result = await _scheduleRepository!.getSchedule();
    return result.schedule;
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
