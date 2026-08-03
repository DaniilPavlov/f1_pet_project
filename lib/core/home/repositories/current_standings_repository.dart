import 'package:f1_pet_project/common/utils/helpers/network_reachability.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:f1_pet_project/services/cache/prefs_json_store.dart';

/// Результат загрузки standings с флагом источника данных.
class StandingsLoadResult {
  const StandingsLoadResult({
    required this.standings,
    required this.fetchedFromNetwork,
    this.offlineFallback = false,
  });

  final StandingsModel standings;
  final bool fetchedFromNetwork;

  /// `true`, если устройство офлайн и данные из prefs (day-cache или stale fallback).
  final bool offlineFallback;
}

/// Текущие standings Jolpica (дневной prefs-кэш + офлайн-fallback).
///
/// Паттерн аналогичен [ScheduleRepository]: дневной [DayPrefsJsonStore] +
/// схлопывание параллельных вызовов через `_inFlight`.
class CurrentStandingsRepository {
  CurrentStandingsRepository({
    DayPrefsJsonStore? driversStore,
    DayPrefsJsonStore? constructorsStore,
  }) : _driversStore = driversStore ??
            const DayPrefsJsonStore(
              dataKey: 'standings_drivers_mr_data',
              dateKey: 'standings_drivers_cache_date',
            ),
       _constructorsStore = constructorsStore ??
            const DayPrefsJsonStore(
              dataKey: 'standings_constructors_mr_data',
              dateKey: 'standings_constructors_cache_date',
            );

  final DayPrefsJsonStore _driversStore;
  final DayPrefsJsonStore _constructorsStore;

  Future<StandingsLoadResult>? _driversInFlight;
  Future<StandingsLoadResult>? _constructorsInFlight;

  /// Отдельные флаги: Home грузит drivers+constructors через [Future.wait].
  var _forceDriversNetwork = false;
  var _forceConstructorsNetwork = false;

  /// Pull-to-refresh: следующий запрос каждого типа идёт в сеть; кэш для офлайна.
  void invalidate() {
    _forceDriversNetwork = true;
    _forceConstructorsNetwork = true;
  }

  Future<StandingsModel> drivers() async {
    final result = await loadDrivers();
    return result.standings;
  }

  Future<StandingsModel> constructors() async {
    final result = await loadConstructors();
    return result.standings;
  }

  /// Загрузка с флагом источника (для UI «из кэша»).
  Future<StandingsLoadResult> loadDrivers() {
    if (_driversInFlight != null) return _driversInFlight!;
    final shouldForce = _forceDriversNetwork;
    _forceDriversNetwork = false;
    final future = _load(
      forceRefresh: shouldForce,
      store: _driversStore,
      apiPath: 'current/driverStandings',
    );
    _driversInFlight = future;
    return future.whenComplete(() {
      if (identical(_driversInFlight, future)) _driversInFlight = null;
    });
  }

  Future<StandingsLoadResult> loadConstructors() {
    if (_constructorsInFlight != null) return _constructorsInFlight!;
    final shouldForce = _forceConstructorsNetwork;
    _forceConstructorsNetwork = false;
    final future = _load(
      forceRefresh: shouldForce,
      store: _constructorsStore,
      apiPath: 'current/constructorStandings',
    );
    _constructorsInFlight = future;
    return future.whenComplete(() {
      if (identical(_constructorsInFlight, future)) _constructorsInFlight = null;
    });
  }

  Future<StandingsLoadResult> _load({
    required bool forceRefresh,
    required DayPrefsJsonStore store,
    required String apiPath,
  }) async {
    if (!forceRefresh) {
      final today = await store.readToday();
      if (today != null) {
        return StandingsLoadResult(
          standings: StandingsModel.fromJson(today),
          fetchedFromNetwork: false,
          offlineFallback: await NetworkReachability.isOffline(),
        );
      }
    }

    try {
      final response = await ApiLoader.get(apiPath);
      final mrData = Map<String, dynamic>.from(response.mrData as Map);
      // CacheInterceptor может отдать offline-кэш как «успех» — не пишем его как today
      // и не врём про network.
      final offline = await NetworkReachability.isOffline();
      if (!offline) {
        await store.writeToday(mrData);
      }
      return StandingsLoadResult(
        standings: StandingsModel.fromJson(mrData),
        fetchedFromNetwork: !offline,
        offlineFallback: offline,
      );
    } on Object catch (error) {
      logger.w('CurrentStandingsRepository: fetch failed ($apiPath), fallback to cache', error: error);
      final stale = await store.readAny();
      if (stale != null) {
        return StandingsLoadResult(
          standings: StandingsModel.fromJson(stale),
          fetchedFromNetwork: false,
          offlineFallback: await NetworkReachability.isOffline(),
        );
      }
      rethrow;
    }
  }
}
