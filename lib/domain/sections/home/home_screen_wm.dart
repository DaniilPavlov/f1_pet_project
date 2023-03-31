import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/home_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:flutter/material.dart';

class HomeScreenWM extends WidgetModel<HomeScreen, HomeScreenModel>
    implements IHomeScreenWM {
  final _currentDrivers = EntityStateNotifier<List<DriverStandingsModel>>();

  final _currentConstructors =
      EntityStateNotifier<List<ConstructorStandingsModel>>();

  final _currentSeason = StateNotifier<String>();

  final _currentRound = StateNotifier<String>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  @override
  ListenableState<EntityState<List<DriverStandingsModel>>> get currentDrivers =>
      _currentDrivers;

  @override
  ListenableState<EntityState<List<ConstructorStandingsModel>>>
      get currentConstructors => _currentConstructors;

  @override
  ListenableState<String> get currentRound => _currentRound;

  @override
  ListenableState<String> get currentSeason => _currentSeason;

  @override
  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  HomeScreenWM(super.model);

  @override
  void initWidgetModel() {
    loadAllData();

    super.initWidgetModel();
  }

  Future<void> loadCurrentDriversStandings() async {
    await execute<StandingsModel>(
      model.loadCurrentDriversStandings,
      before: _currentDrivers.loading,
      onSuccess: (data) {
        _currentDrivers
            .content(data!.StandingsTable.StandingsLists[0].DriverStandings!);
        _currentSeason.accept(data.StandingsTable.StandingsLists[0].season);
        _currentRound.accept(data.StandingsTable.StandingsLists[0].round);
      },
      onError: _currentDrivers.error,
    );
  }

  Future<void> loadCurrentConstructorsStandings() async {
    await execute<StandingsModel>(
      model.loadCurrentConstructorsStandings,
      before: _currentConstructors.loading,
      onSuccess: (data) {
        _currentConstructors.content(
          data!.StandingsTable.StandingsLists[0].ConstructorStandings!,
        );
      },
      onError: _currentConstructors.error,
    );
  }

  Future<void> loadAllData() async {
    _allDataIsLoaded.accept(false);

    await Future.wait(
      [
        loadCurrentDriversStandings(),
        loadCurrentConstructorsStandings(),
      ],
    );

    _allDataIsLoaded.accept(true);
  }
}

HomeScreenWM createHomeScreenWM(BuildContext _) =>
    HomeScreenWM(HomeScreenModel());

abstract class IHomeScreenWM extends IWidgetModel {
  /// Returns current season drivers.
  ListenableState<EntityState<List<DriverStandingsModel>>> get currentDrivers;

  /// Returns current season constructors.
  ListenableState<EntityState<List<ConstructorStandingsModel>>>
      get currentConstructors;

  /// Returns current season round.
  ListenableState<String> get currentRound;

  /// Returns current season year.
  ListenableState<String> get currentSeason;

  /// Returns is all data loaded.
  ListenableState<bool> get allDataIsLoaded;
}
