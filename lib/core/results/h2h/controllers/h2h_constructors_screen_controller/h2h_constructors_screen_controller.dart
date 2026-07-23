import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_catalog_repository.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';
import 'package:f1_pet_project/core/results/h2h/repositories/h2h_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'h2h_constructors_screen_controller.g.dart';

/// Результат сравнения двух конструкторов.
class H2hConstructorsCompareResult {
  const H2hConstructorsCompareResult({
    required this.constructorA,
    required this.constructorB,
    required this.statsA,
    required this.statsB,
    this.season,
  });

  final ConstructorModel constructorA;
  final ConstructorModel constructorB;
  final H2hStats statsA;
  final H2hStats statsB;

  /// `null` — сравнение за карьеру.
  final String? season;
}

/// MobX-контроллер экрана H2H конструкторов.
class H2hConstructorsScreenController = H2hConstructorsScreenControllerBase
    with _$H2hConstructorsScreenController;

/// Фильтры + выбор конструкторов и загрузка сравнения.
abstract class H2hConstructorsScreenControllerBase with Store {
  H2hConstructorsScreenControllerBase({
    this.seasonsRepository,
    H2hRepository? h2hRepository,
    ConstructorCatalogRepository? constructorCatalogRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting
    Future<H2hStats> Function({required String constructorId, String? season})? fetchStatsForTest,
    @visibleForTesting
    Future<List<ConstructorModel>> Function()? loadCurrentConstructorsForTest,
    @visibleForTesting
    Future<List<ConstructorModel>> Function()? loadAllConstructorsForTest,
  }) : _h2hRepository = h2hRepository,
       _dataRefresh = dataRefresh,
       _fetchStatsForTest = fetchStatsForTest,
       _loadCurrentConstructors = loadCurrentConstructorsForTest ?? constructorCatalogRepository!.loadCurrent,
       _loadAllConstructors = loadAllConstructorsForTest ?? constructorCatalogRepository!.loadAll {
    yearController = TextEditingController();
  }

  final SeasonsRepository? seasonsRepository;
  final H2hRepository? _h2hRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<H2hStats> Function({required String constructorId, String? season})? _fetchStatsForTest;
  final Future<List<ConstructorModel>> Function() _loadCurrentConstructors;
  final Future<List<ConstructorModel>> Function() _loadAllConstructors;

  late final TextEditingController yearController;

  /// 0 — карьера, 1 — сезон.
  @observable
  int scopeMode = 0;

  /// В режиме сезона: true — актуальный год, false — выбор года.
  @observable
  bool useCurrentSeason = true;

  /// true — только current/constructors, false — все.
  @observable
  bool currentConstructorsOnly = true;

  @observable
  String latestSeason = '';

  @observable
  bool seasonSelected = false;

  @observable
  ConstructorModel? constructorA;

  @observable
  ConstructorModel? constructorB;

  @observable
  AsyncValue<H2hConstructorsCompareResult?> comparison = const AsyncValue.value();

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
      constructorA != null &&
      constructorB != null &&
      constructorA!.constructorId != constructorB!.constructorId &&
      (!isSeasonScope || selectedSeason != null);

  @computed
  CustomException? get screenError => comparison.exception;

  Future<List<ConstructorModel>> loadConstructorsForPicker() {
    return currentConstructorsOnly ? _loadCurrentConstructors() : _loadAllConstructors();
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
  void setCurrentConstructorsOnly(bool value) {
    if (currentConstructorsOnly == value) {
      return;
    }
    currentConstructorsOnly = value;
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
  void setConstructorA(ConstructorModel constructor) {
    constructorA = constructor;
    _resetComparison();
  }

  @action
  void setConstructorB(ConstructorModel constructor) {
    constructorB = constructor;
    _resetComparison();
  }

  /// Параллельно грузит метрики обоих конструкторов и кладёт результат в [comparison].
  @action
  Future<void> compare() async {
    if (!canCompare) {
      return;
    }
    final a = constructorA!;
    final b = constructorB!;
    final season = selectedSeason;

    await runAsyncLoad<H2hConstructorsCompareResult, H2hConstructorsCompareResult?>(
      fetch: () async {
        final stats = await Future.wait([
          _fetchStats(constructorId: a.constructorId, season: season),
          _fetchStats(constructorId: b.constructorId, season: season),
        ]);
        return H2hConstructorsCompareResult(
          constructorA: a,
          constructorB: b,
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

  Future<H2hStats> _fetchStats({required String constructorId, String? season}) {
    final forTest = _fetchStatsForTest;
    if (forTest != null) {
      return forTest(constructorId: constructorId, season: season);
    }
    return _h2hRepository!.constructorStats(constructorId: constructorId, season: season);
  }
}
