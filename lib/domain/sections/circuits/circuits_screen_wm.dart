import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuits_model.dart';
import 'package:f1_pet_project/domain/sections/circuits/circuits_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuits_screen.dart';
import 'package:flutter/material.dart';

class CircuitsScreenWM extends WidgetModel<CircuitsScreen, CircuitsScreenModel>
    implements ICircuitsScreenWM {
  final _circuits = EntityStateNotifier<List<CircuitModel>>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  @override
  ListenableState<EntityState<List<CircuitModel>>> get circuits => _circuits;

  @override
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
      before: _circuits.loading,
      onSuccess: (data) {
        _circuits.content(data!.CircuitTable.Circuits);
      },
      onError: _circuits.error,
    );
  }

  Future<void> loadAllData() async {
    _allDataIsLoaded.accept(false);

    await Future.wait(
      [
        loadCircuits(),
      ],
    );

    _allDataIsLoaded.accept(true);
  }
}

CircuitsScreenWM createCircuitsScreenWM(BuildContext _) =>
    CircuitsScreenWM(CircuitsScreenModel());

abstract class ICircuitsScreenWM extends IWidgetModel {
  /// Returns circuits.
  ListenableState<EntityState<List<CircuitModel>>> get circuits;

  /// Returns is all data loaded.
  ListenableState<bool> get allDataIsLoaded;
}
