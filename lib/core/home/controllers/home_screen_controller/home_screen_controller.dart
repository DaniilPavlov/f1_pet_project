import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'home_screen_controller.g.dart';

/// MobX-контроллер главного экрана.
class HomeScreenController = HomeScreenControllerBase with _$HomeScreenController;

/// Управляет загрузкой и состоянием турнирных таблиц пилотов и конструкторов.
abstract class HomeScreenControllerBase with Store {
  HomeScreenControllerBase({
    CurrentStandingsRepository? standingsRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<StandingsModel> Function()? fetchCurrentDriversStandingsForTest,
    @visibleForTesting Future<StandingsModel> Function()? fetchCurrentConstructorsStandingsForTest,
  }) : _standingsRepository = standingsRepository,
       _dataRefresh = dataRefresh,
       _fetchCurrentDriversStandingsForTest = fetchCurrentDriversStandingsForTest,
       _fetchCurrentConstructorsStandingsForTest = fetchCurrentConstructorsStandingsForTest;

  final CurrentStandingsRepository? _standingsRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<StandingsModel> Function()? _fetchCurrentDriversStandingsForTest;
  final Future<StandingsModel> Function()? _fetchCurrentConstructorsStandingsForTest;

  @observable
  AsyncValue<List<DriverStandingsModel>> currentDrivers = const AsyncValue.loading();

  @observable
  AsyncValue<List<ConstructorStandingsModel>> currentConstructors = const AsyncValue.loading();

  @observable
  String currentSeason = '';

  @observable
  String currentRound = '';

  @computed
  CustomException? get screenError => firstException([currentDrivers, currentConstructors]);

  /// Параллельно загружает таблицы пилотов и конструкторов.
  @action
  Future<void> loadAllData() async {
    await Future.wait([loadCurrentDriversStandings(), loadCurrentConstructorsStandings()]);
  }

  /// Pull-to-refresh: единый сброс кэшей и перезагрузка таблиц.
  @action
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await loadAllData();
  }

  /// Загружает турнирную таблицу пилотов текущего сезона.
  @action
  Future<void> loadCurrentDriversStandings() async {
    await runAsyncLoad<StandingsModel, List<DriverStandingsModel>>(
      fetch: _fetchCurrentDriversStandings,
      getField: () => currentDrivers,
      setField: (value) => currentDrivers = value,
      onSuccess: (data) {
        final standings = data!.standingsTable.standingsLists[0];
        currentDrivers = currentDrivers.toValue(standings.driverStandings ?? []);
        currentSeason = standings.season;
        currentRound = standings.round;
      },
    );
  }

  /// Загружает турнирную таблицу конструкторов текущего сезона.
  @action
  Future<void> loadCurrentConstructorsStandings() async {
    await runAsyncLoad<StandingsModel, List<ConstructorStandingsModel>>(
      fetch: _fetchCurrentConstructorsStandings,
      getField: () => currentConstructors,
      setField: (value) => currentConstructors = value,
      onSuccess: (data) {
        currentConstructors = currentConstructors.toValue(
          data!.standingsTable.standingsLists[0].constructorStandings ?? [],
        );
      },
    );
  }

  Future<StandingsModel> _fetchCurrentDriversStandings() {
    final forTest = _fetchCurrentDriversStandingsForTest;
    if (forTest != null) {
      return forTest();
    }
    return _standingsRepository!.drivers();
  }

  Future<StandingsModel> _fetchCurrentConstructorsStandings() {
    final forTest = _fetchCurrentConstructorsStandingsForTest;
    if (forTest != null) {
      return forTest();
    }
    return _standingsRepository!.constructors();
  }
}
