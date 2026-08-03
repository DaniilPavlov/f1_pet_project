import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
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
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'h2h_screen_controller.g.dart';

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

/// MobX-контроллер объединённого экрана H2H (пилоты / конструкторы).
class H2hScreenController = H2hScreenControllerBase with _$H2hScreenController;

/// Фильтры + выбор сущностей и загрузка сравнения.
abstract class H2hScreenControllerBase with Store {
  H2hScreenControllerBase({
    H2hMode initialMode = H2hMode.drivers,
    this.seasonsRepository,
    H2hRepository? h2hRepository,
    DriverCatalogRepository? driverCatalogRepository,
    ConstructorCatalogRepository? constructorCatalogRepository,
    CurrentStandingsRepository? currentStandingsRepository,
    AppDataRefresh? dataRefresh,
    AnalyticsGateway? analytics,
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
    @visibleForTesting
    Future<List<DriverModel>> Function()? loadCurrentDriversForTest,
    @visibleForTesting
    Future<List<DriverModel>> Function()? loadAllDriversForTest,
    @visibleForTesting
    Future<List<ConstructorModel>> Function()? loadCurrentConstructorsForTest,
    @visibleForTesting
    Future<List<ConstructorModel>> Function()? loadAllConstructorsForTest,
  }) : _h2hRepository = h2hRepository,
       _currentStandingsRepository = currentStandingsRepository,
       _dataRefresh = dataRefresh,
       _analytics = analytics ?? const NoOpAnalyticsGateway(),
       _compareDriversForTest = compareDriversForTest,
       _compareConstructorsForTest = compareConstructorsForTest,
       _loadCurrentDrivers = loadCurrentDriversForTest ?? driverCatalogRepository?.loadCurrent,
       _loadAllDrivers = loadAllDriversForTest ?? driverCatalogRepository?.loadAll,
       _loadCurrentConstructors =
           loadCurrentConstructorsForTest ?? constructorCatalogRepository?.loadCurrent,
       _loadAllConstructors = loadAllConstructorsForTest ?? constructorCatalogRepository?.loadAll,
       mode = initialMode {
    yearController = TextEditingController();
  }

  final SeasonsRepository? seasonsRepository;
  final H2hRepository? _h2hRepository;
  final CurrentStandingsRepository? _currentStandingsRepository;
  final AppDataRefresh? _dataRefresh;
  final AnalyticsGateway _analytics;
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
  final Future<List<DriverModel>> Function()? _loadCurrentDrivers;
  final Future<List<DriverModel>> Function()? _loadAllDrivers;
  final Future<List<ConstructorModel>> Function()? _loadCurrentConstructors;
  final Future<List<ConstructorModel>> Function()? _loadAllConstructors;

  late final TextEditingController yearController;

  @observable
  H2hMode mode;

  /// 0 — карьера, 1 — сезон.
  @observable
  int scopeMode = 0;

  /// В режиме сезона: true — актуальный год, false — выбор года.
  @observable
  bool useCurrentSeason = true;

  /// true — только current entities, false — полный каталог.
  @observable
  bool currentEntitiesOnly = true;

  @observable
  String latestSeason = '';

  @observable
  bool seasonSelected = false;

  @observable
  DriverModel? driverA;

  @observable
  DriverModel? driverB;

  @observable
  ConstructorModel? constructorA;

  @observable
  ConstructorModel? constructorB;

  @observable
  AsyncValue<H2hCompareResult?> comparison = const AsyncValue.value();

  @computed
  bool get isDriversMode => mode == H2hMode.drivers;

  @computed
  bool get isSeasonScope => scopeMode == 1;

  @computed
  bool get showYearPicker => isSeasonScope && !useCurrentSeason;

  @computed
  String? get selectedSeason {
    if (!isSeasonScope) {
      return null;
    }
    if (useCurrentSeason) {
      return latestSeason.isEmpty ? null : latestSeason;
    }
    return seasonSelected ? yearController.text : null;
  }

  @computed
  bool get canCompare {
    if (!isSeasonScope || selectedSeason != null) {
      if (isDriversMode) {
        return driverA != null && driverB != null && driverA!.driverId != driverB!.driverId;
      }
      return constructorA != null &&
          constructorB != null &&
          constructorA!.constructorId != constructorB!.constructorId;
    }
    return false;
  }

  @computed
  CustomException? get screenError => comparison.exception;

  Future<List<DriverModel>> loadDriversForPicker() {
    final current = _loadCurrentDrivers;
    final all = _loadAllDrivers;
    if (current == null || all == null) {
      throw StateError('Provide DriverCatalogRepository or driver loaders for test');
    }
    return currentEntitiesOnly ? current() : all();
  }

  Future<List<ConstructorModel>> loadConstructorsForPicker() {
    final current = _loadCurrentConstructors;
    final all = _loadAllConstructors;
    if (current == null || all == null) {
      throw StateError('Provide ConstructorCatalogRepository or constructor loaders for test');
    }
    return currentEntitiesOnly ? current() : all();
  }

  void dispose() {
    yearController.dispose();
  }

  /// Загружает годы сезонов для фильтра «текущий / выбор года».
  @action
  Future<void> bootstrap() async {
    final repository = seasonsRepository;
    if (repository == null) {
      return;
    }
    try {
      final years = await repository.getSeasonYears();
      if (years.isNotEmpty) {
        latestSeason = years.first;
        yearController.text = years.first;
        seasonSelected = true;
      }
    } on Object {
      // Оставляем пустые значения — пользователь выберет сезон вручную.
    }
  }

  @action
  void setMode(H2hMode value) {
    if (mode == value) {
      return;
    }
    mode = value;
    driverA = null;
    driverB = null;
    constructorA = null;
    constructorB = null;
    _resetComparison();
  }

  @action
  void setScopeMode(int value) {
    if (scopeMode == value) {
      return;
    }
    scopeMode = value;
    _resetComparison();
  }

  @action
  void setUseCurrentSeason(bool value) {
    if (useCurrentSeason == value) {
      return;
    }
    useCurrentSeason = value;
    if (!value) {
      seasonSelected = yearController.isValidYear;
    }
    _resetComparison();
  }

  @action
  void setCurrentEntitiesOnly(bool value) {
    if (currentEntitiesOnly == value) {
      return;
    }
    currentEntitiesOnly = value;
    driverA = null;
    driverB = null;
    constructorA = null;
    constructorB = null;
    _resetComparison();
  }

  @action
  void onSeasonChanged() {
    seasonSelected = yearController.isValidYear;
    _resetComparison();
  }

  @action
  void setDriverA(DriverModel driver) {
    driverA = driver;
    _resetComparison();
  }

  @action
  void setDriverB(DriverModel driver) {
    driverB = driver;
    _resetComparison();
  }

  @action
  void setConstructorA(ConstructorModel constructor) {
    constructorA = constructor;
    _resetComparison();
  }

  @action
  void setConstructorB(ConstructorModel constructor) {
    constructorB = constructor;
    _resetComparison();
  }

  /// Последовательно грузит обе сущности (глобальный API throttle ~3 req/s).
  @action
  Future<void> compare() async {
    if (!canCompare) {
      return;
    }
    final season = selectedSeason;

    if (isDriversMode) {
      final a = driverA!;
      final b = driverB!;
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
        getField: () => comparison,
        setField: (value) => comparison = value,
        onSuccess: (data) {
          if (data != null) {
            comparison = comparison.toValue(data);
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

    final a = constructorA!;
    final b = constructorB!;
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
      getField: () => comparison,
      setField: (value) => comparison = value,
      onSuccess: (data) {
        if (data != null) {
          comparison = comparison.toValue(data);
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
  @action
  Future<void> refreshComparison() async {
    await _dataRefresh?.clearAll();
    await compare();
  }

  void _resetComparison() {
    comparison = const AsyncValue.value();
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
    return _h2hRepository!.compareDrivers(
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
    return _h2hRepository!.compareConstructors(
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
    final repo = _currentStandingsRepository;
    if (repo == null) {
      return (null, null);
    }
    try {
      final standings = await repo.drivers();
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
