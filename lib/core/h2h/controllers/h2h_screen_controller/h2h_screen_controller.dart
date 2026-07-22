import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/h2h/models/h2h_stats.dart';
import 'package:f1_pet_project/core/h2h/repositories/h2h_repository.dart';
import 'package:f1_pet_project/core/seasons/repositories/seasons_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'h2h_screen_controller.g.dart';

/// Результат сравнения двух пилотов.
class H2hCompareResult {
  const H2hCompareResult({
    required this.driverA,
    required this.driverB,
    required this.statsA,
    required this.statsB,
    this.season,
  });

  final DriverModel driverA;
  final DriverModel driverB;
  final H2hStats statsA;
  final H2hStats statsB;

  /// `null` — сравнение за карьеру.
  final String? season;
}

/// MobX-контроллер экрана H2H.
class H2hScreenController = H2hScreenControllerBase with _$H2hScreenController;

/// Фильтры + выбор пилотов и загрузка сравнения.
abstract class H2hScreenControllerBase with Store {
  H2hScreenControllerBase({
    this.seasonsRepository,
    H2hRepository? h2hRepository,
    DriverCatalogRepository? driverCatalogRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting
    Future<H2hStats> Function({required String driverId, String? season})? fetchStatsForTest,
    @visibleForTesting
    Future<List<DriverModel>> Function()? loadCurrentDriversForTest,
    @visibleForTesting
    Future<List<DriverModel>> Function()? loadAllDriversForTest,
  }) : _h2hRepository = h2hRepository,
       _dataRefresh = dataRefresh,
       _fetchStatsForTest = fetchStatsForTest,
       _loadCurrentDrivers = loadCurrentDriversForTest ?? driverCatalogRepository!.loadCurrent,
       _loadAllDrivers = loadAllDriversForTest ?? driverCatalogRepository!.loadAll {
    yearController = TextEditingController();
  }

  final SeasonsRepository? seasonsRepository;
  final H2hRepository? _h2hRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<H2hStats> Function({required String driverId, String? season})? _fetchStatsForTest;
  final Future<List<DriverModel>> Function() _loadCurrentDrivers;
  final Future<List<DriverModel>> Function() _loadAllDrivers;

  late final TextEditingController yearController;

  /// 0 — карьера, 1 — сезон.
  @observable
  int scopeMode = 0;

  /// В режиме сезона: true — актуальный год, false — выбор года.
  @observable
  bool useCurrentSeason = true;

  /// true — только current/drivers, false — все пилоты.
  @observable
  bool currentDriversOnly = true;

  @observable
  String latestSeason = '';

  @observable
  bool seasonSelected = false;

  @observable
  DriverModel? driverA;

  @observable
  DriverModel? driverB;

  @observable
  AsyncValue<H2hCompareResult?> comparison = const AsyncValue.value();

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
  bool get canCompare =>
      driverA != null &&
      driverB != null &&
      driverA!.driverId != driverB!.driverId &&
      (!isSeasonScope || selectedSeason != null);

  @computed
  CustomException? get screenError => comparison.exception;

  Future<List<DriverModel>> loadDriversForPicker() {
    return currentDriversOnly ? _loadCurrentDrivers() : _loadAllDrivers();
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
  void setScopeMode(int mode) {
    if (scopeMode == mode) {
      return;
    }
    scopeMode = mode;
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
  void setCurrentDriversOnly(bool value) {
    if (currentDriversOnly == value) {
      return;
    }
    currentDriversOnly = value;
    driverA = null;
    driverB = null;
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

  /// Параллельно грузит метрики обоих пилотов и кладёт результат в [comparison].
  @action
  Future<void> compare() async {
    if (!canCompare) {
      return;
    }
    final a = driverA!;
    final b = driverB!;
    final season = selectedSeason;

    await runAsyncLoad<H2hCompareResult, H2hCompareResult?>(
      fetch: () async {
        final stats = await Future.wait([
          _fetchStats(driverId: a.driverId, season: season),
          _fetchStats(driverId: b.driverId, season: season),
        ]);
        return H2hCompareResult(
          driverA: a,
          driverB: b,
          statsA: stats[0],
          statsB: stats[1],
          season: season,
        );
      },
      getField: () => comparison,
      setField: (value) => comparison = value,
      onSuccess: (data) {
        if (data != null) {
          comparison = comparison.toValue(data);
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

  Future<H2hStats> _fetchStats({required String driverId, String? season}) {
    final forTest = _fetchStatsForTest;
    if (forTest != null) {
      return forTest(driverId: driverId, season: season);
    }
    return _h2hRepository!.driverStats(driverId: driverId, season: season);
  }
}
