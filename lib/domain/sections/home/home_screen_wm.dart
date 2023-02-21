import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/current_drivers_standings/current_drivers_standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/home_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:flutter/material.dart';

class HomeScreenWM extends WidgetModel<HomeScreen, HomeScreenModel> {
  final _currentDriversElements = EntityStateNotifier<List<DriverStanding>>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  ListenableState<EntityState<List<DriverStanding>>>
      get currentDriversElements => _currentDriversElements;

  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  HomeScreenWM(super.model);

  @override
  void initWidgetModel() {
    loadAllData();

    super.initWidgetModel();
  }

  Future<void> loadCurrentDriversStandings() async {
    await execute<CurrentDriversStandings>(
      model.loadCurrentDriversStandings,
      before: _currentDriversElements.loading,
      onSuccess: (data) {
        _currentDriversElements
            .content(data!.standingsTable.standingsLists[0].driverStandings);
      },
      onError: _currentDriversElements.error,
    );
  }

  Future<void> loadAllData() async {
    // _allDataIsLoaded.accept(false);

    await Future.wait(
      [
        loadCurrentDriversStandings(),
      ],
    );

    _allDataIsLoaded.accept(true);
  }
}

HomeScreenWM createHomeScreenWM(BuildContext _) =>
    HomeScreenWM(HomeScreenModel());
