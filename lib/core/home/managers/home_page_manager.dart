import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/offline_cached_banner.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/core/home/state/state_holders/home_page_state_holder.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';

/// Загружает турнирные таблицы пилотов и конструкторов для главного экрана.
class HomePageManager {
  HomePageManager({
    required HomePageStateHolder holder,
    CurrentStandingsRepository? currentStandingsRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<StandingsModel> Function()? fetchCurrentDriversStandingsForTest,
    @visibleForTesting Future<StandingsModel> Function()? fetchCurrentConstructorsStandingsForTest,
  }) : _holder = holder,
       _currentStandingsRepository = currentStandingsRepository,
       _dataRefresh = dataRefresh,
       _fetchCurrentDriversStandingsForTest = fetchCurrentDriversStandingsForTest,
       _fetchCurrentConstructorsStandingsForTest = fetchCurrentConstructorsStandingsForTest;

  final HomePageStateHolder _holder;
  final CurrentStandingsRepository? _currentStandingsRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<StandingsModel> Function()? _fetchCurrentDriversStandingsForTest;
  final Future<StandingsModel> Function()? _fetchCurrentConstructorsStandingsForTest;

  var _driversOfflineFallback = false;
  var _constructorsOfflineFallback = false;

  /// Параллельно загружает таблицы пилотов и конструкторов.
  Future<void> loadAllData() async {
    await Future.wait([loadCurrentDriversStandings(), loadCurrentConstructorsStandings()]);
  }

  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await loadAllData();
  }

  /// Загружает турнирную таблицу пилотов текущего сезона.
  Future<void> loadCurrentDriversStandings() async {
    await runAsyncLoad<StandingsModel, List<DriverStandingsModel>>(
      fetch: _fetchCurrentDriversStandings,
      getField: () => _holder.viewModel.currentDrivers,
      setField: (value) => _holder.setViewModel(_holder.viewModel.copyWith(currentDrivers: value)),
      onSuccess: (data) {
        final standings = data!.standingsTable.standingsLists[0];
        _holder.setViewModel(
          _holder.viewModel.copyWith(
            currentDrivers: _holder.viewModel.currentDrivers.toValue(standings.driverStandings ?? []),
            currentSeason: standings.season,
            currentRound: standings.round,
          ),
        );
        _syncCachedFlag();
      },
    );
  }

  /// Загружает турнирную таблицу конструкторов текущего сезона.
  Future<void> loadCurrentConstructorsStandings() async {
    await runAsyncLoad<StandingsModel, List<ConstructorStandingsModel>>(
      fetch: _fetchCurrentConstructorsStandings,
      getField: () => _holder.viewModel.currentConstructors,
      setField: (value) => _holder.setViewModel(_holder.viewModel.copyWith(currentConstructors: value)),
      onSuccess: (data) {
        _holder.setViewModel(
          _holder.viewModel.copyWith(
            currentConstructors: _holder.viewModel.currentConstructors.toValue(
              data!.standingsTable.standingsLists[0].constructorStandings ?? [],
            ),
          ),
        );
        _syncCachedFlag();
      },
    );
  }

  /// После появления сети — спрятать баннер без перезагрузки таблиц.
  Future<void> dismissOfflineBannerIfOnline() async {
    _holder.setViewModel(
      _holder.viewModel.copyWith(
        showingCachedData: await clearOfflineBannerIfOnline(
          currentlyShowing: _holder.viewModel.showingCachedData,
        ),
      ),
    );
  }

  void _syncCachedFlag() {
    _holder.setViewModel(
      _holder.viewModel.copyWith(
        showingCachedData: _driversOfflineFallback || _constructorsOfflineFallback,
      ),
    );
  }

  Future<StandingsModel> _fetchCurrentDriversStandings() async {
    final forTest = _fetchCurrentDriversStandingsForTest;
    if (forTest != null) {
      _driversOfflineFallback = false;
      return forTest();
    }
    final result = await _currentStandingsRepository!.loadDrivers();
    _driversOfflineFallback = result.offlineFallback;
    return result.standings;
  }

  Future<StandingsModel> _fetchCurrentConstructorsStandings() async {
    final forTest = _fetchCurrentConstructorsStandingsForTest;
    if (forTest != null) {
      _constructorsOfflineFallback = false;
      return forTest();
    }
    final result = await _currentStandingsRepository!.loadConstructors();
    _constructorsOfflineFallback = result.offlineFallback;
    return result.standings;
  }
}
