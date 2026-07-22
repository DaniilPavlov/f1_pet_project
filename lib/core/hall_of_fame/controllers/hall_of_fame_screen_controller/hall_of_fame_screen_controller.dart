import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/hall_of_fame/repositories/season_standings_repository.dart';
import 'package:f1_pet_project/core/seasons/repositories/seasons_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'hall_of_fame_screen_controller.g.dart';

/// MobX-контроллер экрана «Зал славы».
class HallOfFameScreenController = HallOfFameScreenControllerBase with _$HallOfFameScreenController;

/// Управляет зачётами пилотов/конструкторов за выбранный сезон.
abstract class HallOfFameScreenControllerBase with Store {
  HallOfFameScreenControllerBase({
    this.seasonsRepository,
    SeasonStandingsRepository? standingsRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting
    Future<StandingsModel> Function(String year)? fetchDriversStandingsForTest,
    @visibleForTesting
    Future<StandingsModel> Function(String year)? fetchConstructorsStandingsForTest,
  }) : _standingsRepository = standingsRepository,
       _dataRefresh = dataRefresh,
       _fetchDriversStandingsForTest = fetchDriversStandingsForTest,
       _fetchConstructorsStandingsForTest = fetchConstructorsStandingsForTest {
    yearController = TextEditingController(text: '2026');
  }

  final SeasonsRepository? seasonsRepository;
  final SeasonStandingsRepository? _standingsRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<StandingsModel> Function(String year)? _fetchDriversStandingsForTest;
  final Future<StandingsModel> Function(String year)? _fetchConstructorsStandingsForTest;

  late final TextEditingController yearController;

  @observable
  AsyncValue<List<StandingsListsModel>> driversStandings = const AsyncValue.loading();

  @observable
  AsyncValue<List<StandingsListsModel>> constructorsStandings = const AsyncValue.loading();

  @observable
  bool fieldsInputted = true;

  @computed
  CustomException? get screenError => firstException([driversStandings, constructorsStandings]);

  /// Освобождает контроллер поля сезона.
  void dispose() {
    yearController.dispose();
  }

  /// Проверяет корректность выбранного года сезона.
  @action
  void checkFields() {
    fieldsInputted = yearController.isValidYear;
  }

  /// Подставляет актуальный сезон из API (если доступен) и грузит таблицы.
  @action
  Future<void> bootstrap() async {
    final repository = seasonsRepository;
    if (repository != null) {
      try {
        final years = await repository.getSeasonYears();
        if (years.isNotEmpty) {
          yearController.text = years.first;
          fieldsInputted = true;
        }
      } on Object {
        // Оставляем fallback-год в контроллере.
      }
    }
    await loadAllData();
  }

  /// Загружает зачёты пилотов и конструкторов за выбранный сезон.
  @action
  Future<void> loadAllData() async {
    final year = yearController.text;
    await Future.wait([loadConstructorsStandings(year: year), loadDriversStandings(year: year)]);
  }

  /// Pull-to-refresh / ErrorBody: сброс кэшей и перезагрузка.
  @action
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await loadAllData();
  }

  /// Загружает зачёт пилотов за указанный сезон.
  @action
  Future<void> loadDriversStandings({required String year}) async {
    await runAsyncLoad<StandingsModel, List<StandingsListsModel>>(
      fetch: () => _fetchDriversStandings(year: year),
      getField: () => driversStandings,
      setField: (value) => driversStandings = value,
      onSuccess: (data) => driversStandings = driversStandings.toValue(data!.standingsTable.standingsLists),
    );
  }

  /// Загружает зачёт конструкторов за указанный сезон.
  @action
  Future<void> loadConstructorsStandings({required String year}) async {
    await runAsyncLoad<StandingsModel, List<StandingsListsModel>>(
      fetch: () => _fetchConstructorsStandings(year: year),
      getField: () => constructorsStandings,
      setField: (value) => constructorsStandings = value,
      onSuccess: (data) => constructorsStandings = constructorsStandings.toValue(data!.standingsTable.standingsLists),
    );
  }

  Future<StandingsModel> _fetchDriversStandings({required String year}) {
    final forTest = _fetchDriversStandingsForTest;
    if (forTest != null) {
      return forTest(year);
    }
    return _standingsRepository!.drivers(year: year);
  }

  Future<StandingsModel> _fetchConstructorsStandings({required String year}) {
    final forTest = _fetchConstructorsStandingsForTest;
    if (forTest != null) {
      return forTest(year);
    }
    return _standingsRepository!.constructors(year: year);
  }
}
