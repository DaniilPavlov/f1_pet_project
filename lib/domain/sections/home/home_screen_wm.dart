import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/home_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreenWM extends WidgetModel<HomeScreen, HomeScreenModel>
    implements IHomeScreenWM {
  HomeScreenWM(super._model);
  final _currentDrivers = EntityStateNotifier<List<DriverStandingsModel>>();

  final _currentConstructors =
      EntityStateNotifier<List<ConstructorStandingsModel>>();

  final _currentSeason = StateNotifier<String>();

  final _currentRound = StateNotifier<String>();

  final _screenError = StateNotifier<CustomException?>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  @override
  ListenableState<CustomException?> get screenError => _screenError;

  @override
  ValueListenable<EntityState<List<DriverStandingsModel>>> get currentDrivers =>
      _currentDrivers;

  @override
  ValueListenable<EntityState<List<ConstructorStandingsModel>>>
      get currentConstructors => _currentConstructors;

  @override
  ListenableState<String> get currentRound => _currentRound;

  @override
  ListenableState<String> get currentSeason => _currentSeason;

  @override
  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  @override
  void initWidgetModel() {
    loadAllData();

    super.initWidgetModel();
  }

  @override
  Future<void> loadAllData() async {
    _screenError.accept(null);
    _allDataIsLoaded.accept(false);

    await Future.wait(
      [
        loadCurrentDriversStandings(),
        loadCurrentConstructorsStandings(),
      ],
    );

    _allDataIsLoaded.accept(true);
  }

  Future<void> loadCurrentDriversStandings() async {
    await execute<StandingsModel>(
      model.loadCurrentDriversStandings,
      before: _currentDrivers.loading,
      onSuccess: (data) {
        _currentDrivers
            .content(data!.standingsTable.standingsLists[0].driverStandings!);
        _currentSeason.accept(data.standingsTable.standingsLists[0].season);
        _currentRound.accept(data.standingsTable.standingsLists[0].round);
      },
      onError: (value) {
        _screenError.accept(value);
        _currentDrivers.error(value);
      },
    );
  }

  Future<void> loadCurrentConstructorsStandings() async {
    await execute<StandingsModel>(
      model.loadCurrentConstructorsStandings,
      before: _currentConstructors.loading,
      onSuccess: (data) {
        _currentConstructors.content(
          data!.standingsTable.standingsLists[0].constructorStandings!,
        );
      },
      onError: (value) {
        _screenError.accept(value);
        _currentDrivers.error(value);
      },
    );
  }
}

HomeScreenWM createHomeScreenWM(BuildContext _) =>
    HomeScreenWM(HomeScreenModel());

abstract interface class IHomeScreenWM implements IWidgetModel {
  /// Returns current season drivers.
  ValueListenable<EntityState<List<DriverStandingsModel>>> get currentDrivers;

  /// Returns current season constructors.
  ValueListenable<EntityState<List<ConstructorStandingsModel>>>
      get currentConstructors;

  /// Returns current season round.
  ListenableState<String> get currentRound;

  /// Returns current season year.
  ListenableState<String> get currentSeason;

  /// Returns error.
  ListenableState<CustomException?> get screenError;

  /// Returns is all data loaded.
  ListenableState<bool> get allDataIsLoaded;

  /// Loads all data.
  void loadAllData();
}
