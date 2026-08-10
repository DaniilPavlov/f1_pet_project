import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/results/hall_of_fame/repositories/season_standings_repository.dart';
import 'package:f1_pet_project/core/results/hall_of_fame/state/state_holders/hall_of_fame_page_state_holder.dart';
import 'package:f1_pet_project/data/models/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';

/// Управляет зачётами пилотов/конструкторов за выбранный сезон.
class HallOfFamePageManager {
  HallOfFamePageManager({
    required HallOfFamePageStateHolder holder,
    SeasonsRepository? seasonsRepository,
    SeasonStandingsRepository? standingsRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<StandingsModel> Function(String year)? fetchDriversStandingsForTest,
    @visibleForTesting Future<StandingsModel> Function(String year)? fetchConstructorsStandingsForTest,
  }) : _holder = holder,
       _seasonsRepository = seasonsRepository,
       _standingsRepository = standingsRepository,
       _dataRefresh = dataRefresh,
       _fetchDriversStandingsForTest = fetchDriversStandingsForTest,
       _fetchConstructorsStandingsForTest = fetchConstructorsStandingsForTest;

  final HallOfFamePageStateHolder _holder;
  final SeasonsRepository? _seasonsRepository;
  final SeasonStandingsRepository? _standingsRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<StandingsModel> Function(String year)? _fetchDriversStandingsForTest;
  final Future<StandingsModel> Function(String year)? _fetchConstructorsStandingsForTest;

  /// Ввод года для фильтра.
  final yearController = TextEditingController(text: '2026');

  var _disposed = false;

  /// Проверяет корректность выбранного года сезона.
  void checkFields() {
    _holder.setViewModel(_holder.viewModel.copyWith(fieldsInputted: yearController.isValidYear));
  }

  /// Подставляет актуальный сезон из API (если доступен) и грузит таблицы.
  Future<void> bootstrap() async {
    final repository = _seasonsRepository;
    if (repository != null) {
      try {
        final years = await repository.getSeasonYears();
        if (years.isNotEmpty) {
          yearController.text = years.first;
          _holder.setViewModel(_holder.viewModel.copyWith(fieldsInputted: true));
        }
      } on Object {
        // Оставляем fallback-год в контроллере.
      }
    }
    if (_disposed) {
      return;
    }
    await loadAllData();
  }

  /// Загружает зачёты пилотов и конструкторов за выбранный сезон.
  Future<void> loadAllData() async {
    final year = yearController.text;
    await Future.wait([loadConstructorsStandings(year: year), loadDriversStandings(year: year)]);
  }

  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    if (_disposed) {
      return;
    }
    await loadAllData();
  }

  /// Загружает зачёт пилотов за указанный сезон.
  Future<void> loadDriversStandings({required String year}) async {
    await runAsyncLoad<StandingsModel, List<StandingsListsModel>>(
      fetch: () => _fetchDriversStandings(year: year),
      getField: () => _holder.viewModel.driversStandings,
      setField: (value) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(_holder.viewModel.copyWith(driversStandings: value));
      },
      onSuccess: (data) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(
          _holder.viewModel.copyWith(
            driversStandings: _holder.viewModel.driversStandings.toValue(data!.standingsTable.standingsLists),
          ),
        );
      },
    );
  }

  /// Загружает зачёт конструкторов за указанный сезон.
  Future<void> loadConstructorsStandings({required String year}) async {
    await runAsyncLoad<StandingsModel, List<StandingsListsModel>>(
      fetch: () => _fetchConstructorsStandings(year: year),
      getField: () => _holder.viewModel.constructorsStandings,
      setField: (value) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(_holder.viewModel.copyWith(constructorsStandings: value));
      },
      onSuccess: (data) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(
          _holder.viewModel.copyWith(
            constructorsStandings: _holder.viewModel.constructorsStandings.toValue(
              data!.standingsTable.standingsLists,
            ),
          ),
        );
      },
    );
  }

  /// Очищает ресурсы менеджера.
  void dispose() {
    _disposed = true;
    yearController.dispose();
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
