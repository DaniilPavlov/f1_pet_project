import 'package:f1_pet_project/data/models/sections/home/circuits/circuits_model.dart';
import 'package:f1_pet_project/domain/sections/home/home_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

class HomeScreenWM extends WidgetModel<HomeScreen, HomeScreenModel> {
  HomeScreenWM(super.model);

  ListenableState<EntityState<List<CircuitModel>>> get circuitsElements =>
      _circuitsElements;

  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  final _circuitsElements = EntityStateNotifier<List<CircuitModel>>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  @override
  void initWidgetModel() {
    loadAllData();

    super.initWidgetModel();
  }

  Future<void> loadCircuits() async {
    await execute<CircuitsModel>(
      model.loadCircuits,
      before: _circuitsElements.loading,
      onSuccess: (data) {
        _circuitsElements.content(data!.circuitTable.circuits);
      },
      onError: _circuitsElements.error,
    );
  }

  Future<void> loadAllData() async {
    // _allDataIsLoaded.accept(false);

    await Future.wait(
      [
        loadCircuits(),
      ],
    );

    _allDataIsLoaded.accept(true);
  }
}

HomeScreenWM createHomeScreenWM(BuildContext _) =>
    HomeScreenWM(HomeScreenModel());
