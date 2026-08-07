import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_catalog_repository.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_entity_compare_data.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_mode.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';
import 'package:f1_pet_project/core/results/h2h/repositories/h2h_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Результат сравнения двух сущностей (имена для таблицы).
class H2hCompareResult {
  const H2hCompareResult({
    required this.nameA,
    required this.nameB,
    required this.statsA,
    required this.statsB,
    required this.timeline,
    this.season,
    this.constructorIdA,
    this.constructorIdB,
  });

  final String nameA;
  final String nameB;
  final H2hStats statsA;
  final H2hStats statsB;
  final H2hPointsTimeline timeline;

  /// `null` — сравнение за карьеру.
  final String? season;

  /// Jolpica `constructorId` для цвета линии графика (если известен).
  final String? constructorIdA;
  final String? constructorIdB;
}

/// Состояние объединённого экрана H2H.
@immutable
class H2hState {
  const H2hState({
    this.mode = H2hMode.drivers,
    this.scopeMode = 0,
    this.useCurrentSeason = true,
    this.currentEntitiesOnly = true,
    this.latestSeason = '',
    this.seasonSelected = false,
    this.driverA,
    this.driverB,
    this.constructorA,
    this.constructorB,
    this.comparison = const Loadable.value(),
  });

  final H2hMode mode;

  /// 0 — карьера, 1 — сезон.
  final int scopeMode;

  /// В режиме сезона: true — актуальный год, false — выбор года.
  final bool useCurrentSeason;

  /// true — только current entities, false — полный каталог.
  final bool currentEntitiesOnly;

  final String latestSeason;
  final bool seasonSelected;
  final DriverModel? driverA;
  final DriverModel? driverB;
  final ConstructorModel? constructorA;
  final ConstructorModel? constructorB;
  final Loadable<H2hCompareResult?> comparison;

  bool get isDriversMode => mode == H2hMode.drivers;

  bool get isSeasonScope => scopeMode == 1;

  bool get showYearPicker => isSeasonScope && !useCurrentSeason;

  CustomException? get screenError => comparison.exception;

  H2hState copyWith({
    H2hMode? mode,
    int? scopeMode,
    bool? useCurrentSeason,
    bool? currentEntitiesOnly,
    String? latestSeason,
    bool? seasonSelected,
    DriverModel? driverA,
    DriverModel? driverB,
    ConstructorModel? constructorA,
    ConstructorModel? constructorB,
    Loadable<H2hCompareResult?>? comparison,
    bool clearDriverA = false,
    bool clearDriverB = false,
    bool clearConstructorA = false,
    bool clearConstructorB = false,
  }) {
    return H2hState(
      mode: mode ?? this.mode,
      scopeMode: scopeMode ?? this.scopeMode,
      useCurrentSeason: useCurrentSeason ?? this.useCurrentSeason,
      currentEntitiesOnly: currentEntitiesOnly ?? this.currentEntitiesOnly,
      latestSeason: latestSeason ?? this.latestSeason,
      seasonSelected: seasonSelected ?? this.seasonSelected,
      driverA: clearDriverA ? null : (driverA ?? this.driverA),
      driverB: clearDriverB ? null : (driverB ?? this.driverB),
      constructorA: clearConstructorA ? null : (constructorA ?? this.constructorA),
      constructorB: clearConstructorB ? null : (constructorB ?? this.constructorB),
      comparison: comparison ?? this.comparison,
    );
  }
}

/// Фильтры + выбор сущностей и загрузка сравнения.
class H2hScreenController extends Notifier<H2hState> {
  H2hScreenController(
    this.initialMode, {
    @visibleForTesting SeasonsRepository? seasonsRepositoryForTest,
    @visibleForTesting
    Future<H2hLoadedCompare> Function({
      required String driverIdA,
      required String driverIdB,
      String? season,
    })?
    compareDriversForTest,
    @visibleForTesting
    Future<H2hLoadedCompare> Function({
      required String constructorIdA,
      required String constructorIdB,
      String? season,
    })?
    compareConstructorsForTest,
    @visibleForTesting Future<List<DriverModel>> Function()? loadCurrentDriversForTest,
    @visibleForTesting Future<List<DriverModel>> Function()? loadAllDriversForTest,
    @visibleForTesting Future<List<ConstructorModel>> Function()? loadCurrentConstructorsForTest,
    @visibleForTesting Future<List<ConstructorModel>> Function()? loadAllConstructorsForTest,
    @visibleForTesting AppDataRefresh? dataRefreshForTest,
    @visibleForTesting AnalyticsGateway? analyticsForTest,
  }) : _seasonsRepositoryForTest = seasonsRepositoryForTest,
       _compareDriversForTest = compareDriversForTest,
       _compareConstructorsForTest = compareConstructorsForTest,
       _loadCurrentDriversForTest = loadCurrentDriversForTest,
       _loadAllDriversForTest = loadAllDriversForTest,
       _loadCurrentConstructorsForTest = loadCurrentConstructorsForTest,
       _loadAllConstructorsForTest = loadAllConstructorsForTest,
       _dataRefreshForTest = dataRefreshForTest,
       _analyticsForTest = analyticsForTest;

  final H2hMode initialMode;
  final SeasonsRepository? _seasonsRepositoryForTest;
  final Future<H2hLoadedCompare> Function({
    required String driverIdA,
    required String driverIdB,
    String? season,
  })?
  _compareDriversForTest;
  final Future<H2hLoadedCompare> Function({
    required String constructorIdA,
    required String constructorIdB,
    String? season,
  })?
  _compareConstructorsForTest;
  final Future<List<DriverModel>> Function()? _loadCurrentDriversForTest;
  final Future<List<DriverModel>> Function()? _loadAllDriversForTest;
  final Future<List<ConstructorModel>> Function()? _loadCurrentConstructorsForTest;
  final Future<List<ConstructorModel>> Function()? _loadAllConstructorsForTest;
  final AppDataRefresh? _dataRefreshForTest;
  final AnalyticsGateway? _analyticsForTest;

  late final TextEditingController yearController;

  bool get _usingTestFetches =>
      _compareDriversForTest != null ||
      _compareConstructorsForTest != null ||
      _loadCurrentDriversForTest != null ||
      _loadAllDriversForTest != null;

  AnalyticsGateway get _analytics => _analyticsForTest ?? ref.read(analyticsGatewayProvider);

  H2hRepository get _h2hRepository => ref.read(h2hRepositoryProvider);

  DriverCatalogRepository get _driverCatalog => ref.read(driverCatalogRepositoryProvider);

  ConstructorCatalogRepository get _constructorCatalog => ref.read(constructorCatalogRepositoryProvider);

  CurrentStandingsRepository get _currentStandings => ref.read(currentStandingsRepositoryProvider);

  String? get selectedSeason {
    if (!state.isSeasonScope) {
      return null;
    }
    if (state.useCurrentSeason) {
      return state.latestSeason.isEmpty ? null : state.latestSeason;
    }
    return state.seasonSelected ? yearController.text : null;
  }

  bool get canCompare {
    if (!state.isSeasonScope || selectedSeason != null) {
      if (state.isDriversMode) {
        return state.driverA != null &&
            state.driverB != null &&
            state.driverA!.driverId != state.driverB!.driverId;
      }
      return state.constructorA != null &&
          state.constructorB != null &&
          state.constructorA!.constructorId != state.constructorB!.constructorId;
    }
    return false;
  }

  @override
  H2hState build() {
    yearController = TextEditingController();
    ref.onDispose(yearController.dispose);
    return H2hState(mode: initialMode);
  }

  Future<List<DriverModel>> loadDriversForPicker() {
    final current = _loadCurrentDriversForTest;
    final all = _loadAllDriversForTest;
    if (current != null && all != null) {
      return state.currentEntitiesOnly ? current() : all();
    }
    return state.currentEntitiesOnly ? _driverCatalog.loadCurrent() : _driverCatalog.loadAll();
  }

  Future<List<ConstructorModel>> loadConstructorsForPicker() {
    final current = _loadCurrentConstructorsForTest;
    final all = _loadAllConstructorsForTest;
    if (current != null && all != null) {
      return state.currentEntitiesOnly ? current() : all();
    }
    return state.currentEntitiesOnly
        ? _constructorCatalog.loadCurrent()
        : _constructorCatalog.loadAll();
  }

  /// Загружает годы сезонов для фильтра «текущий / выбор года».
  Future<void> bootstrap() async {
    final repository = _seasonsRepositoryForTest ??
        (_usingTestFetches ? null : ref.read(seasonsRepositoryProvider));
    if (repository == null) {
      return;
    }
    try {
      final years = await repository.getSeasonYears();
      if (years.isNotEmpty) {
        yearController.text = years.first;
        state = state.copyWith(latestSeason: years.first, seasonSelected: true);
      }
    } on Object {
      // Оставляем пустые значения — пользователь выберет сезон вручную.
    }
  }

  void setMode(H2hMode value) {
    if (state.mode == value) {
      return;
    }
    state = state.copyWith(
      mode: value,
      clearDriverA: true,
      clearDriverB: true,
      clearConstructorA: true,
      clearConstructorB: true,
      comparison: const Loadable.value(),
    );
  }

  void setScopeMode(int value) {
    if (state.scopeMode == value) {
      return;
    }
    state = state.copyWith(scopeMode: value, comparison: const Loadable.value());
  }

  void setUseCurrentSeason(bool value) {
    if (state.useCurrentSeason == value) {
      return;
    }
    state = state.copyWith(
      useCurrentSeason: value,
      seasonSelected: value ? state.seasonSelected : yearController.isValidYear,
      comparison: const Loadable.value(),
    );
  }

  void setCurrentEntitiesOnly(bool value) {
    if (state.currentEntitiesOnly == value) {
      return;
    }
    state = state.copyWith(
      currentEntitiesOnly: value,
      clearDriverA: true,
      clearDriverB: true,
      clearConstructorA: true,
      clearConstructorB: true,
      comparison: const Loadable.value(),
    );
  }

  void onSeasonChanged() {
    state = state.copyWith(
      seasonSelected: yearController.isValidYear,
      comparison: const Loadable.value(),
    );
  }

  void setDriverA(DriverModel driver) {
    state = state.copyWith(driverA: driver, comparison: const Loadable.value());
  }

  void setDriverB(DriverModel driver) {
    state = state.copyWith(driverB: driver, comparison: const Loadable.value());
  }

  void setConstructorA(ConstructorModel constructor) {
    state = state.copyWith(constructorA: constructor, comparison: const Loadable.value());
  }

  void setConstructorB(ConstructorModel constructor) {
    state = state.copyWith(constructorB: constructor, comparison: const Loadable.value());
  }

  /// Последовательно грузит обе сущности (глобальный API throttle ~3 req/s).
  Future<void> compare() async {
    if (!canCompare) {
      return;
    }
    final season = selectedSeason;

    if (state.isDriversMode) {
      final a = state.driverA!;
      final b = state.driverB!;
      await runAsyncLoad<H2hCompareResult, H2hCompareResult?>(
        fetch: () async {
          final loaded = await _compareDrivers(
            driverIdA: a.driverId,
            driverIdB: b.driverId,
            season: season,
          );
          final teamIds = await _constructorIdsForDrivers(a.driverId, b.driverId);
          return H2hCompareResult(
            nameA: '${a.givenName} ${a.familyName}'.trim(),
            nameB: '${b.givenName} ${b.familyName}'.trim(),
            statsA: loaded.statsA,
            statsB: loaded.statsB,
            timeline: loaded.timeline,
            season: season,
            constructorIdA: teamIds.$1,
            constructorIdB: teamIds.$2,
          );
        },
        getField: () => state.comparison,
        setField: (value) => state = state.copyWith(comparison: value),
        onSuccess: (data) {
          if (data != null) {
            state = state.copyWith(comparison: state.comparison.toValue(data));
            _analytics.log(
              H2hCompared(
                driverA: data.nameA,
                driverB: data.nameB,
                season: season,
                scopeMode: season == null ? 'career' : 'season',
              ),
            );
          }
        },
      );
      return;
    }

    final a = state.constructorA!;
    final b = state.constructorB!;
    await runAsyncLoad<H2hCompareResult, H2hCompareResult?>(
      fetch: () async {
        final loaded = await _compareConstructors(
          constructorIdA: a.constructorId,
          constructorIdB: b.constructorId,
          season: season,
        );
        return H2hCompareResult(
          nameA: a.name,
          nameB: b.name,
          statsA: loaded.statsA,
          statsB: loaded.statsB,
          timeline: loaded.timeline,
          season: season,
          constructorIdA: a.constructorId,
          constructorIdB: b.constructorId,
        );
      },
      getField: () => state.comparison,
      setField: (value) => state = state.copyWith(comparison: value),
      onSuccess: (data) {
        if (data != null) {
          state = state.copyWith(comparison: state.comparison.toValue(data));
          _analytics.log(
            H2hConstructorsCompared(
              constructorA: data.nameA,
              constructorB: data.nameB,
              season: season,
              scopeMode: season == null ? 'career' : 'season',
            ),
          );
        }
      },
    );
  }

  /// ErrorBody retry: сброс кэшей и повторное сравнение.
  Future<void> refreshComparison() async {
    if (_dataRefreshForTest != null) {
      await _dataRefreshForTest.clearAll();
    } else if (!_usingTestFetches) {
      await ref.read(appDataRefreshProvider).clearAll();
    }
    await compare();
  }

  Future<H2hLoadedCompare> _compareDrivers({
    required String driverIdA,
    required String driverIdB,
    String? season,
  }) {
    final forTest = _compareDriversForTest;
    if (forTest != null) {
      return forTest(driverIdA: driverIdA, driverIdB: driverIdB, season: season);
    }
    return _h2hRepository.compareDrivers(
      driverIdA: driverIdA,
      driverIdB: driverIdB,
      season: season,
    );
  }

  Future<H2hLoadedCompare> _compareConstructors({
    required String constructorIdA,
    required String constructorIdB,
    String? season,
  }) {
    final forTest = _compareConstructorsForTest;
    if (forTest != null) {
      return forTest(
        constructorIdA: constructorIdA,
        constructorIdB: constructorIdB,
        season: season,
      );
    }
    return _h2hRepository.compareConstructors(
      constructorIdA: constructorIdA,
      constructorIdB: constructorIdB,
      season: season,
    );
  }

  /// Текущие команды пилотов из standings (для цвета линий графика).
  Future<(String?, String?)> _constructorIdsForDrivers(
    String driverIdA,
    String driverIdB,
  ) async {
    if (_compareDriversForTest != null) {
      return (null, null);
    }
    try {
      final standings = await _currentStandings.drivers();
      String? idA;
      String? idB;
      for (final list in standings.standingsTable.standingsLists) {
        final rows = list.driverStandings;
        if (rows == null) {
          continue;
        }
        for (final row in rows) {
          if (idA == null && row.driver.driverId == driverIdA && row.constructors.isNotEmpty) {
            idA = row.constructors.first.constructorId;
          }
          if (idB == null && row.driver.driverId == driverIdB && row.constructors.isNotEmpty) {
            idB = row.constructors.first.constructorId;
          }
          if (idA != null && idB != null) {
            return (idA, idB);
          }
        }
      }
      return (idA, idB);
    } on Object {
      return (null, null);
    }
  }
}

final h2hScreenControllerProvider =
    NotifierProvider.autoDispose.family<H2hScreenController, H2hState, H2hMode>(
      H2hScreenController.new,
    );
