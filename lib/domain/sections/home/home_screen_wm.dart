import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/home_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:flutter/material.dart';

class HomeScreenWM extends WidgetModel<HomeScreen, HomeScreenModel> {
  final _currentDriversElements =
      EntityStateNotifier<List<DriverStandingsModel>>();

  final _currentConstructorsElements =
      EntityStateNotifier<List<ConstructorStandingsModel>>();

  final _currentSeason = StateNotifier<String>();

  final _currentRound = StateNotifier<String>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  ListenableState<EntityState<List<DriverStandingsModel>>>
      get currentDriversElements => _currentDriversElements;

  ListenableState<EntityState<List<ConstructorStandingsModel>>>
      get currentConstructorsElements => _currentConstructorsElements;

  ListenableState<String> get currentRound => _currentRound;

  ListenableState<String> get currentSeason => _currentSeason;

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
      before: _currentDriversElements.loading,
      onSuccess: (data) {
        _currentDriversElements
            .content(data!.StandingsTable.StandingsLists[0].DriverStandings!);
        _currentSeason.accept(data.StandingsTable.StandingsLists[0].season);
        _currentRound.accept(data.StandingsTable.StandingsLists[0].round);
      },
      onError: _currentDriversElements.error,
    );
  }

  Future<void> loadCurrentConstructorsStandings() async {
    await execute<StandingsModel>(
      model.loadCurrentConstructorsStandings,
      before: _currentConstructorsElements.loading,
      onSuccess: (data) {
        _currentConstructorsElements.content(
          data!.StandingsTable.StandingsLists[0].ConstructorStandings!,
        );
      },
      onError: _currentConstructorsElements.error,
    );
  }

  Future<void> loadAllData() async {
    // _allDataIsLoaded.accept(false);

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
