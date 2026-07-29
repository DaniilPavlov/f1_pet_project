import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:f1_pet_project/services/cache/prefs_json_store.dart';

/// Результат загрузки standings с флагом источника данных.
class StandingsLoadResult {
  const StandingsLoadResult({required this.standings, required this.fetchedFromNetwork});

  final StandingsModel standings;
  final bool fetchedFromNetwork;
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

  var _forceNetwork = false;

  /// Pull-to-refresh: следующий запрос идёт в сеть; кэш остаётся для офлайна.
  void invalidate() => _forceNetwork = true;

  Future<StandingsModel> drivers() async {
    final result = await _getDrivers();
    return result.standings;
  }

  Future<StandingsModel> constructors() async {
    final result = await _getConstructors();
    return result.standings;
  }

  /// Читает и сбрасывает [_forceNetwork] синхронно, чтобы параллельный вызов
  /// [_getConstructors] тоже успел увидеть флаг до его сброса.
  bool _consumeForceNetwork() {
    final v = _forceNetwork;
    _forceNetwork = false;
    return v;
  }

  Future<StandingsLoadResult> _getDrivers() {
    if (_driversInFlight != null) return _driversInFlight!;
    final shouldForce = _consumeForceNetwork();
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

  Future<StandingsLoadResult> _getConstructors() {
    if (_constructorsInFlight != null) return _constructorsInFlight!;
    final shouldForce = _consumeForceNetwork();
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
        );
      }
    }

    try {
      final response = await ApiLoader.get(apiPath);
      final mrData = Map<String, dynamic>.from(response.mrData as Map);
      await store.writeToday(mrData);
      return StandingsLoadResult(
        standings: StandingsModel.fromJson(mrData),
        fetchedFromNetwork: true,
      );
    } on Object catch (error) {
      logger.w('CurrentStandingsRepository: fetch failed ($apiPath), fallback to cache', error: error);
      final stale = await store.readAny();
      if (stale != null) {
        return StandingsLoadResult(
          standings: StandingsModel.fromJson(stale),
          fetchedFromNetwork: false,
        );
      }
      rethrow;
    }
  }
}
