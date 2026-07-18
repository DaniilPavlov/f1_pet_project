import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/fetch_from_loader.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/circuits/loaders/circuits_loader.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/circuits/models/circuits_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'circuits_screen_controller.g.dart';

/// MobX-контроллер экрана трасс.
class CircuitsScreenController = CircuitsScreenControllerBase with _$CircuitsScreenController;

/// Управляет загрузкой трасс и переключением вкладок списка/карты.
abstract class CircuitsScreenControllerBase with Store {
  CircuitsScreenControllerBase({Future<CircuitsModel> Function()? fetchCircuits})
    : _fetchCircuitsOverride = fetchCircuits;

  final Future<CircuitsModel> Function()? _fetchCircuitsOverride;

  final pageController = PageController();

  @observable
  AsyncValue<List<CircuitModel>> circuits = const AsyncValue.loading();

  @observable
  int activePage = 0;

  @computed
  CustomException? get screenError => circuits.exception;

  /// Освобождает ресурсы контроллера страниц.
  void dispose() {
    pageController.dispose();
  }

  /// Загружает список трасс с сервера.
  @action
  Future<void> loadCircuits() async {
    await runAsyncLoad<CircuitsModel, List<CircuitModel>>(
      fetch: _fetchCircuits,
      getField: () => circuits,
      setField: (value) => circuits = value,
      onSuccess: (data) => circuits = circuits.toValue(data!.circuitTable.circuits),
    );
  }

  /// Переключает активную вкладку (карта или список).
  @action
  void changeActivePage(int value) {
    activePage = value;
    if (pageController.hasClients) {
      pageController.animateToPage(activePage, curve: Curves.ease, duration: const Duration(milliseconds: 250));
    }
  }

  Future<CircuitsModel> _fetchCircuits() =>
      fetchFromLoader(override: _fetchCircuitsOverride, load: CircuitsLoader.loadData, parse: CircuitsModel.fromJson);
}
