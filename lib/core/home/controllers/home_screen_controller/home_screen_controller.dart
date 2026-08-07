import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/offline_cached_banner.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние главного экрана: турнирные таблицы пилотов и конструкторов.
@immutable
class HomeState {
  const HomeState({
    this.currentDrivers = const Loadable.loading(),
    this.currentConstructors = const Loadable.loading(),
    this.currentSeason = '',
    this.currentRound = '',
    this.showingCachedData = false,
  });

  final Loadable<List<DriverStandingsModel>> currentDrivers;
  final Loadable<List<ConstructorStandingsModel>> currentConstructors;
  final String currentSeason;
  final String currentRound;

  /// Офлайн-fallback: данные из кэша после сбоя сети.
  final bool showingCachedData;

  CustomException? get screenError => firstException([currentDrivers, currentConstructors]);

  HomeState copyWith({
    Loadable<List<DriverStandingsModel>>? currentDrivers,
    Loadable<List<ConstructorStandingsModel>>? currentConstructors,
    String? currentSeason,
    String? currentRound,
    bool? showingCachedData,
  }) {
    return HomeState(
      currentDrivers: currentDrivers ?? this.currentDrivers,
      currentConstructors: currentConstructors ?? this.currentConstructors,
      currentSeason: currentSeason ?? this.currentSeason,
      currentRound: currentRound ?? this.currentRound,
      showingCachedData: showingCachedData ?? this.showingCachedData,
    );
  }
}

/// Управляет загрузкой и состоянием турнирных таблиц пилотов и конструкторов.
class HomeScreenController extends Notifier<HomeState> {
  HomeScreenController({
    @visibleForTesting Future<StandingsModel> Function()? fetchCurrentDriversStandingsForTest,
    @visibleForTesting Future<StandingsModel> Function()? fetchCurrentConstructorsStandingsForTest,
  }) : _fetchCurrentDriversStandingsForTest = fetchCurrentDriversStandingsForTest,
       _fetchCurrentConstructorsStandingsForTest = fetchCurrentConstructorsStandingsForTest;

  final Future<StandingsModel> Function()? _fetchCurrentDriversStandingsForTest;
  final Future<StandingsModel> Function()? _fetchCurrentConstructorsStandingsForTest;

  var _driversOfflineFallback = false;
  var _constructorsOfflineFallback = false;

  @override
  HomeState build() => const HomeState();

  /// Параллельно загружает таблицы пилотов и конструкторов.
  Future<void> loadAllData() async {
    await Future.wait([loadCurrentDriversStandings(), loadCurrentConstructorsStandings()]);
  }

  /// Pull-to-refresh: единый сброс кэшей и перезагрузка таблиц.
  Future<void> refreshAll() async {
    if (_fetchCurrentDriversStandingsForTest == null && _fetchCurrentConstructorsStandingsForTest == null) {
      await ref.read(appDataRefreshProvider).clearAll();
    }
    await loadAllData();
  }

  /// Загружает турнирную таблицу пилотов текущего сезона.
  Future<void> loadCurrentDriversStandings() async {
    await runAsyncLoad<StandingsModel, List<DriverStandingsModel>>(
      fetch: _fetchCurrentDriversStandings,
      getField: () => state.currentDrivers,
      setField: (value) => state = state.copyWith(currentDrivers: value),
      onSuccess: (data) {
        final standings = data!.standingsTable.standingsLists[0];
        state = state.copyWith(
          currentDrivers: state.currentDrivers.toValue(standings.driverStandings ?? []),
          currentSeason: standings.season,
          currentRound: standings.round,
        );
        _syncCachedFlag();
      },
    );
  }

  /// Загружает турнирную таблицу конструкторов текущего сезона.
  Future<void> loadCurrentConstructorsStandings() async {
    await runAsyncLoad<StandingsModel, List<ConstructorStandingsModel>>(
      fetch: _fetchCurrentConstructorsStandings,
      getField: () => state.currentConstructors,
      setField: (value) => state = state.copyWith(currentConstructors: value),
      onSuccess: (data) {
        state = state.copyWith(
          currentConstructors: state.currentConstructors.toValue(
            data!.standingsTable.standingsLists[0].constructorStandings ?? [],
          ),
        );
        _syncCachedFlag();
      },
    );
  }

  void _syncCachedFlag() {
    state = state.copyWith(
      showingCachedData: _driversOfflineFallback || _constructorsOfflineFallback,
    );
  }

  /// После появления сети — спрятать баннер без перезагрузки таблиц.
  Future<void> dismissOfflineBannerIfOnline() async {
    state = state.copyWith(
      showingCachedData: await clearOfflineBannerIfOnline(currentlyShowing: state.showingCachedData),
    );
  }

  Future<StandingsModel> _fetchCurrentDriversStandings() async {
    final forTest = _fetchCurrentDriversStandingsForTest;
    if (forTest != null) {
      _driversOfflineFallback = false;
      return forTest();
    }
    final result = await ref.read(currentStandingsRepositoryProvider).loadDrivers();
    _driversOfflineFallback = result.offlineFallback;
    return result.standings;
  }

  Future<StandingsModel> _fetchCurrentConstructorsStandings() async {
    final forTest = _fetchCurrentConstructorsStandingsForTest;
    if (forTest != null) {
      _constructorsOfflineFallback = false;
      return forTest();
    }
    final result = await ref.read(currentStandingsRepositoryProvider).loadConstructors();
    _constructorsOfflineFallback = result.offlineFallback;
    return result.standings;
  }
}

final homeScreenControllerProvider = NotifierProvider.autoDispose<HomeScreenController, HomeState>(
  HomeScreenController.new,
);
