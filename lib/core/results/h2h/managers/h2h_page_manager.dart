import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_catalog_repository.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_compare_result.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_entity_compare_data.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_mode.dart';
import 'package:f1_pet_project/core/results/h2h/repositories/h2h_repository.dart';
import 'package:f1_pet_project/core/results/h2h/state/state_holders/h2h_page_state_holder.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';

/// Фильтры + выбор сущностей и загрузка сравнения.
class H2hPageManager {
  H2hPageManager({
    required H2hPageStateHolder holder,
    SeasonsRepository? seasonsRepository,
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
    @visibleForTesting Future<List<DriverModel>> Function()? loadCurrentDriversForTest,
    @visibleForTesting Future<List<DriverModel>> Function()? loadAllDriversForTest,
    @visibleForTesting Future<List<ConstructorModel>> Function()? loadCurrentConstructorsForTest,
    @visibleForTesting Future<List<ConstructorModel>> Function()? loadAllConstructorsForTest,
  }) : _holder = holder,
       _seasonsRepository = seasonsRepository,
       _h2hRepository = h2hRepository,
       _driverCatalogRepository = driverCatalogRepository,
       _constructorCatalogRepository = constructorCatalogRepository,
       _currentStandingsRepository = currentStandingsRepository,
       _dataRefresh = dataRefresh,
       _analytics = analytics,
       _compareDriversForTest = compareDriversForTest,
       _compareConstructorsForTest = compareConstructorsForTest,
       _loadCurrentDriversForTest = loadCurrentDriversForTest,
       _loadAllDriversForTest = loadAllDriversForTest,
       _loadCurrentConstructorsForTest = loadCurrentConstructorsForTest,
       _loadAllConstructorsForTest = loadAllConstructorsForTest;

  final H2hPageStateHolder _holder;
  final SeasonsRepository? _seasonsRepository;
  final H2hRepository? _h2hRepository;
  final DriverCatalogRepository? _driverCatalogRepository;
  final ConstructorCatalogRepository? _constructorCatalogRepository;
  final CurrentStandingsRepository? _currentStandingsRepository;
  final AppDataRefresh? _dataRefresh;
  final AnalyticsGateway? _analytics;
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

  /// Контроллер ввода года для фильтра по сезону.
  final yearController = TextEditingController();

  /// Очищает ресурсы менеджера.
  void dispose() => yearController.dispose();

  String? get selectedSeason {
    final viewModel = _holder.viewModel;
    if (!viewModel.isSeasonScope) {
      return null;
    }
    if (viewModel.useCurrentSeason) {
      return viewModel.latestSeason.isEmpty ? null : viewModel.latestSeason;
    }
    return viewModel.seasonSelected ? yearController.text : null;
  }

  bool get canCompare {
    final viewModel = _holder.viewModel;
    if (!viewModel.isSeasonScope || selectedSeason != null) {
      if (viewModel.isDriversMode) {
        return viewModel.driverA != null &&
            viewModel.driverB != null &&
            viewModel.driverA!.driverId != viewModel.driverB!.driverId;
      }
      return viewModel.constructorA != null &&
          viewModel.constructorB != null &&
          viewModel.constructorA!.constructorId != viewModel.constructorB!.constructorId;
    }
    return false;
  }

  Future<List<DriverModel>> loadDriversForPicker() {
    final current = _loadCurrentDriversForTest;
    final all = _loadAllDriversForTest;
    if (current != null && all != null) {
      return _holder.viewModel.currentEntitiesOnly ? current() : all();
    }
    return _holder.viewModel.currentEntitiesOnly
        ? _driverCatalogRepository!.loadCurrent()
        : _driverCatalogRepository!.loadAll();
  }

  Future<List<ConstructorModel>> loadConstructorsForPicker() {
    final current = _loadCurrentConstructorsForTest;
    final all = _loadAllConstructorsForTest;
    if (current != null && all != null) {
      return _holder.viewModel.currentEntitiesOnly ? current() : all();
    }
    return _holder.viewModel.currentEntitiesOnly
        ? _constructorCatalogRepository!.loadCurrent()
        : _constructorCatalogRepository!.loadAll();
  }

  /// Загружает доступные годы для фильтра.
  Future<void> bootstrap() async {
    final repository = _seasonsRepository;
    if (repository == null) {
      return;
    }
    try {
      final years = await repository.getSeasonYears();
      if (years.isNotEmpty) {
        yearController.text = years.first;
        _holder.setViewModel(
          _holder.viewModel.copyWith(latestSeason: years.first, seasonSelected: true),
        );
      }
    } on Object {
      // Оставляем пустые значения — пользователь выберет сезон вручную.
    }
  }

  /// Переключает режим (пилоты / команды).
  void setMode(H2hMode value) {
    if (_holder.viewModel.mode == value) {
      return;
    }
    _holder.setViewModel(
      _holder.viewModel.copyWith(
        mode: value,
        driverA: null,
        driverB: null,
        constructorA: null,
        constructorB: null,
        comparison: const Loadable.value(),
      ),
    );
  }

  /// Устанавливает область сравнения (карьера / сезон).
  void setScopeMode(int value) {
    if (_holder.viewModel.scopeMode == value) {
      return;
    }
    _holder.setViewModel(
      _holder.viewModel.copyWith(scopeMode: value, comparison: const Loadable.value()),
    );
  }

  /// Переключает между текущим сезоном и выбором года.
  void setUseCurrentSeason(bool value) {
    if (_holder.viewModel.useCurrentSeason == value) {
      return;
    }
    _holder.setViewModel(
      _holder.viewModel.copyWith(
        useCurrentSeason: value,
        seasonSelected: value ? _holder.viewModel.seasonSelected : yearController.isValidYear,
        comparison: const Loadable.value(),
      ),
    );
  }

  /// Фильтрует на текущих / всех участников.
  void setCurrentEntitiesOnly(bool value) {
    if (_holder.viewModel.currentEntitiesOnly == value) {
      return;
    }
    _holder.setViewModel(
      _holder.viewModel.copyWith(
        currentEntitiesOnly: value,
        driverA: null,
        driverB: null,
        constructorA: null,
        constructorB: null,
        comparison: const Loadable.value(),
      ),
    );
  }

  /// Обновляет состояние при смене года.
  void onSeasonChanged() {
    _holder.setViewModel(
      _holder.viewModel.copyWith(
        seasonSelected: yearController.isValidYear,
        comparison: const Loadable.value(),
      ),
    );
  }

  /// Выбирает первого пилота для сравнения.
  void setDriverA(DriverModel driver) {
    _holder.setViewModel(
      _holder.viewModel.copyWith(driverA: driver, comparison: const Loadable.value()),
    );
  }

  /// Выбирает второго пилота для сравнения.
  void setDriverB(DriverModel driver) {
    _holder.setViewModel(
      _holder.viewModel.copyWith(driverB: driver, comparison: const Loadable.value()),
    );
  }

  /// Выбирает первую команду для сравнения.
  void setConstructorA(ConstructorModel constructor) {
    _holder.setViewModel(
      _holder.viewModel.copyWith(constructorA: constructor, comparison: const Loadable.value()),
    );
  }

  /// Выбирает вторую команду для сравнения.
  void setConstructorB(ConstructorModel constructor) {
    _holder.setViewModel(
      _holder.viewModel.copyWith(constructorB: constructor, comparison: const Loadable.value()),
    );
  }

  /// Загружает и строит сравнение выбранных сущностей.
  Future<void> compare() async {
    if (!canCompare) {
      return;
    }
    final season = selectedSeason;
    final viewModel = _holder.viewModel;

    if (viewModel.isDriversMode) {
      final a = viewModel.driverA!;
      final b = viewModel.driverB!;
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
        getField: () => _holder.viewModel.comparison,
        setField: (value) => _holder.setViewModel(_holder.viewModel.copyWith(comparison: value)),
        onSuccess: (data) {
          if (data != null) {
            _holder.setViewModel(
              _holder.viewModel.copyWith(comparison: _holder.viewModel.comparison.toValue(data)),
            );
            _analytics?.log(
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

    final a = viewModel.constructorA!;
    final b = viewModel.constructorB!;
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
      getField: () => _holder.viewModel.comparison,
      setField: (value) => _holder.setViewModel(_holder.viewModel.copyWith(comparison: value)),
      onSuccess: (data) {
        if (data != null) {
          _holder.setViewModel(
            _holder.viewModel.copyWith(comparison: _holder.viewModel.comparison.toValue(data)),
          );
          _analytics?.log(
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

  /// Перезагружает и повторно строит сравнение.
  Future<void> refreshComparison() async {
    await _dataRefresh?.clearAll();
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
    if (_compareDriversForTest != null) {
      return (null, null);
    }
    try {
      final standings = await _currentStandingsRepository!.drivers();
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
