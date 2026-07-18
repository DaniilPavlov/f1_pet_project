import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/fetch_from_loader.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/home/loaders/current_constructors_standings_loader.dart';
import 'package:f1_pet_project/core/home/loaders/current_drivers_standings_loader.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/core/home/models/standings/standings_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:mobx/mobx.dart';

part 'home_screen_controller.g.dart';

/// MobX-контроллер главного экрана.
class HomeScreenController = HomeScreenControllerBase with _$HomeScreenController;

/// Управляет загрузкой и состоянием турнирных таблиц пилотов и конструкторов.
abstract class HomeScreenControllerBase with Store {
  HomeScreenControllerBase({
    Future<StandingsModel> Function()? fetchCurrentDriversStandings,
    Future<StandingsModel> Function()? fetchCurrentConstructorsStandings,
  }) : _fetchCurrentDriversStandingsOverride = fetchCurrentDriversStandings,
       _fetchCurrentConstructorsStandingsOverride = fetchCurrentConstructorsStandings;

  final Future<StandingsModel> Function()? _fetchCurrentDriversStandingsOverride;
  final Future<StandingsModel> Function()? _fetchCurrentConstructorsStandingsOverride;

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

  Future<StandingsModel> _fetchCurrentDriversStandings() => fetchFromLoader(
    override: _fetchCurrentDriversStandingsOverride,
    load: CurrentDriversStandingsLoader.loadData,
    parse: StandingsModel.fromJson,
  );

  Future<StandingsModel> _fetchCurrentConstructorsStandings() => fetchFromLoader(
    override: _fetchCurrentConstructorsStandingsOverride,
    load: CurrentConstructorsStandingsLoader.loadData,
    parse: StandingsModel.fromJson,
  );
}
