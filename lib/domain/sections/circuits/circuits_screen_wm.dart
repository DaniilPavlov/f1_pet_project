import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuits_model.dart';
import 'package:f1_pet_project/domain/sections/circuits/circuits_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuits_screen.dart';
import 'package:flutter/material.dart';

class CircuitsScreenWM extends WidgetModel<CircuitsScreen, CircuitsScreenModel>
    implements ICircuitsScreenWM {
  final _circuits = EntityStateNotifier<List<CircuitModel>>();

  final _screenError = StateNotifier<CustomException?>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  @override
  ListenableState<CustomException?> get screenError => _screenError;

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

  @override
  Future<void> loadAllData() async {
    _screenError.accept(null);
    _allDataIsLoaded.accept(false);

    await Future.wait(
      [
        loadCircuits(),
      ],
    );

    _allDataIsLoaded.accept(true);
  }

  Future<void> loadCircuits() async {
    await execute<CircuitsModel>(
      model.loadCircuits,
      before: _circuits.loading,
      onSuccess: (data) {
        _circuits.content(data!.CircuitTable.Circuits);
      },
      onError: (value) {
        _screenError.accept(value);
        _circuits.error(value);
      },
    );
  }
}

CircuitsScreenWM createCircuitsScreenWM(BuildContext _) =>
    CircuitsScreenWM(CircuitsScreenModel());

abstract class ICircuitsScreenWM extends IWidgetModel {
  /// Returns circuits.
  ListenableState<EntityState<List<CircuitModel>>> get circuits;

  /// Returns error.
  ListenableState<CustomException?> get screenError;

  /// Returns is all data loaded.
  ListenableState<bool> get allDataIsLoaded;

  /// Loads all data.
  void loadAllData();
}
