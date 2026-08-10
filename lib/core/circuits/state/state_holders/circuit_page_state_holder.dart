import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/circuits/state/state_models/circuit_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [CircuitPageViewModel] для экрана трассы.
class CircuitPageStateHolder extends Notifier<CircuitPageViewModel> {
  CircuitPageStateHolder(this.circuit);

  /// Трасса, для которой открыт экран.
  final CircuitModel circuit;

  @override
  CircuitPageViewModel build() => const CircuitPageViewModel();

  CircuitPageViewModel get viewModel => state;

  void setViewModel(CircuitPageViewModel value) => state = value;
}
