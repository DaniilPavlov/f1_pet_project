import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/results/hall_of_fame/repositories/season_standings_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние экрана «Зал славы».
@immutable
class HallOfFameState {
  const HallOfFameState({
    this.driversStandings = const Loadable.loading(),
    this.constructorsStandings = const Loadable.loading(),
    this.fieldsInputted = true,
  });

  final Loadable<List<StandingsListsModel>> driversStandings;
  final Loadable<List<StandingsListsModel>> constructorsStandings;
  final bool fieldsInputted;

  CustomException? get screenError => firstException([driversStandings, constructorsStandings]);

  HallOfFameState copyWith({
    Loadable<List<StandingsListsModel>>? driversStandings,
    Loadable<List<StandingsListsModel>>? constructorsStandings,
    bool? fieldsInputted,
  }) {
    return HallOfFameState(
      driversStandings: driversStandings ?? this.driversStandings,
      constructorsStandings: constructorsStandings ?? this.constructorsStandings,
      fieldsInputted: fieldsInputted ?? this.fieldsInputted,
    );
  }
}

/// Управляет зачётами пилотов/конструкторов за выбранный сезон.
class HallOfFameScreenController extends Notifier<HallOfFameState> {
  HallOfFameScreenController({
    @visibleForTesting SeasonsRepository? seasonsRepositoryForTest,
    @visibleForTesting Future<StandingsModel> Function(String year)? fetchDriversStandingsForTest,
    @visibleForTesting Future<StandingsModel> Function(String year)? fetchConstructorsStandingsForTest,
    @visibleForTesting AppDataRefresh? dataRefreshForTest,
  }) : _seasonsRepositoryForTest = seasonsRepositoryForTest,
       _fetchDriversStandingsForTest = fetchDriversStandingsForTest,
       _fetchConstructorsStandingsForTest = fetchConstructorsStandingsForTest,
       _dataRefreshForTest = dataRefreshForTest;

  final SeasonsRepository? _seasonsRepositoryForTest;
  final Future<StandingsModel> Function(String year)? _fetchDriversStandingsForTest;
  final Future<StandingsModel> Function(String year)? _fetchConstructorsStandingsForTest;
  final AppDataRefresh? _dataRefreshForTest;

  late final TextEditingController yearController;

  SeasonStandingsRepository get _standingsRepository => ref.read(seasonStandingsRepositoryProvider);

  bool get _usingTestFetches =>
      _fetchDriversStandingsForTest != null || _fetchConstructorsStandingsForTest != null;

  @override
  HallOfFameState build() {
    yearController = TextEditingController(text: '2026');
    ref.onDispose(yearController.dispose);
    return const HallOfFameState();
  }

  /// Проверяет корректность выбранного года сезона.
  void checkFields() {
    state = state.copyWith(fieldsInputted: yearController.isValidYear);
  }

  /// Подставляет актуальный сезон из API (если доступен) и грузит таблицы.
  Future<void> bootstrap() async {
    final repository = _seasonsRepositoryForTest ??
        (_usingTestFetches ? null : ref.read(seasonsRepositoryProvider));
    if (repository != null) {
      try {
        final years = await repository.getSeasonYears();
        if (years.isNotEmpty) {
          yearController.text = years.first;
          state = state.copyWith(fieldsInputted: true);
        }
      } on Object {
        // Оставляем fallback-год в контроллере.
      }
    }
    await loadAllData();
  }

  /// Загружает зачёты пилотов и конструкторов за выбранный сезон.
  Future<void> loadAllData() async {
    final year = yearController.text;
    await Future.wait([loadConstructorsStandings(year: year), loadDriversStandings(year: year)]);
  }

  /// Pull-to-refresh / ErrorBody: сброс кэшей и перезагрузка.
  Future<void> refreshAll() async {
    if (_dataRefreshForTest != null) {
      await _dataRefreshForTest.clearAll();
    } else if (!_usingTestFetches) {
      await ref.read(appDataRefreshProvider).clearAll();
    }
    await loadAllData();
  }

  /// Загружает зачёт пилотов за указанный сезон.
  Future<void> loadDriversStandings({required String year}) async {
    await runAsyncLoad<StandingsModel, List<StandingsListsModel>>(
      fetch: () => _fetchDriversStandings(year: year),
      getField: () => state.driversStandings,
      setField: (value) => state = state.copyWith(driversStandings: value),
      onSuccess: (data) =>
          state = state.copyWith(driversStandings: state.driversStandings.toValue(data!.standingsTable.standingsLists)),
    );
  }

  /// Загружает зачёт конструкторов за указанный сезон.
  Future<void> loadConstructorsStandings({required String year}) async {
    await runAsyncLoad<StandingsModel, List<StandingsListsModel>>(
      fetch: () => _fetchConstructorsStandings(year: year),
      getField: () => state.constructorsStandings,
      setField: (value) => state = state.copyWith(constructorsStandings: value),
      onSuccess: (data) => state = state.copyWith(
        constructorsStandings: state.constructorsStandings.toValue(data!.standingsTable.standingsLists),
      ),
    );
  }

  Future<StandingsModel> _fetchDriversStandings({required String year}) {
    final forTest = _fetchDriversStandingsForTest;
    if (forTest != null) {
      return forTest(year);
    }
    return _standingsRepository.drivers(year: year);
  }

  Future<StandingsModel> _fetchConstructorsStandings({required String year}) {
    final forTest = _fetchConstructorsStandingsForTest;
    if (forTest != null) {
      return forTest(year);
    }
    return _standingsRepository.constructors(year: year);
  }
}

final hallOfFameScreenControllerProvider =
    NotifierProvider.autoDispose<HallOfFameScreenController, HallOfFameState>(
      HallOfFameScreenController.new,
    );
