import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuits_model.dart';
import 'package:f1_pet_project/domain/sections/circuits/circuits_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuits_screen.dart';
import 'package:flutter/material.dart';

class CircuitsScreenWM
    extends WidgetModel<CircuitsScreen, CircuitsScreenModel> {
  final _circuitsElements = EntityStateNotifier<List<CircuitModel>>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  ListenableState<EntityState<List<CircuitModel>>> get circuitsElements =>
      _circuitsElements;

  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  CircuitsScreenWM(super.model);

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
        _circuitsElements.content(data!.CircuitTable.Circuits);
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

CircuitsScreenWM createHomeScreenWM(BuildContext _) =>
    CircuitsScreenWM(CircuitsScreenModel());
