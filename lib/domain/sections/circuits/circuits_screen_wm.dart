import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuits_model.dart';
import 'package:f1_pet_project/domain/sections/circuits/circuits_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuits_screen.dart';
import 'package:f1_pet_project/presentation/sections/circuits/widgets/circuits_map_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CircuitsScreenWM extends WidgetModel<CircuitsScreen, CircuitsScreenModel>
    implements ICircuitsScreenWM {
  CircuitsScreenWM(super._model);
  final _circuits = EntityStateNotifier<List<CircuitModel>>();

  final _screenError = StateNotifier<CustomException?>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  final _activePage = StateNotifier<int>(initValue: 0);

  final _pageController = PageController();

  @override
  PageController get pageController => _pageController;

  @override
  ListenableState<int> get activePage => _activePage;

  @override
  ListenableState<CustomException?> get screenError => _screenError;

  @override
  ValueListenable<EntityState<List<CircuitModel>>> get circuits => _circuits;

  @override
  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  @override
  void initWidgetModel() {
    loadAllData();

    super.initWidgetModel();
  }

  @override
  void changeActivePage(int value) {
    _activePage.accept(value);

    pageController.animateToPage(
      _activePage.value!,
      curve: Curves.ease,
      duration: const Duration(milliseconds: 250),
    );
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

  @override
  Future<void> openCircuitInfo(int id) async {
    final circuit = _circuits.value.data![id];
    await showModalBottomSheet<Widget>(
      context: context,
      builder: (context) {
        return CircuitsMapBottomSheet(circuit: circuit);
      },
    );
  }

  Future<void> loadCircuits() async {
    await execute<CircuitsModel>(
      model.loadCircuits,
      before: _circuits.loading,
      onSuccess: (data) {
        _circuits.content(data!.circuitTable.circuits);
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

abstract interface class ICircuitsScreenWM implements IWidgetModel {
  PageController get pageController;

  /// Returns circuits.
  ValueListenable<EntityState<List<CircuitModel>>> get circuits;

  /// Returns error.
  ListenableState<CustomException?> get screenError;

  /// Returns is all data loaded.
  ListenableState<bool> get allDataIsLoaded;

  /// Returns active page id.
  ListenableState<int> get activePage;

  /// Open short info about circuit.
  Future<void> openCircuitInfo(int id);

  /// Changes active page.
  void changeActivePage(int value);

  /// Loads all data.
  void loadAllData();
}
