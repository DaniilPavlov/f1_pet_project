import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/circuits/loaders/circuit_history_loader.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_race_win.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:mobx/mobx.dart';

part 'circuit_screen_controller.g.dart';

/// MobX-контроллер экрана трассы.
class CircuitScreenController = CircuitScreenControllerBase with _$CircuitScreenController;

/// Загружает историю побед на выбранной трассе.
abstract class CircuitScreenControllerBase with Store {
  CircuitScreenControllerBase({
    required this.circuit,
    Future<List<CircuitRaceWin>> Function({required String circuitId})? fetchWinners,
  }) : _fetchWinnersOverride = fetchWinners;

  final CircuitModel circuit;
  final Future<List<CircuitRaceWin>> Function({required String circuitId})? _fetchWinnersOverride;

  @observable
  AsyncValue<List<CircuitRaceWin>> winners = const AsyncValue.loading();

  @computed
  CustomException? get screenError => firstException([winners]);

  @computed
  bool get isLoaded => winners.isValue && winners.value != null;

  /// Загружает (или перезагружает) список победителей.
  @action
  Future<void> loadWinners() async {
    await runAsyncLoad(
      fetch: () => _fetchWinners(circuitId: circuit.circuitId),
      getField: () => winners,
      setField: (value) => winners = value,
      onSuccess: (data) {
        if (data != null) {
          winners = winners.toValue(data);
        }
      },
    );
  }

  Future<List<CircuitRaceWin>> _fetchWinners({required String circuitId}) {
    final override = _fetchWinnersOverride;
    if (override != null) {
      return override(circuitId: circuitId);
    }
    return CircuitHistoryLoader.loadWinners(circuitId: circuitId);
  }
}
