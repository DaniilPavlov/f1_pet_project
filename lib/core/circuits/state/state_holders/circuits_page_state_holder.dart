import 'package:f1_pet_project/core/circuits/state/state_models/circuits_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [CircuitsPageViewModel] для экрана списка трасс.
class CircuitsPageStateHolder extends Notifier<CircuitsPageViewModel> {
  @override
  CircuitsPageViewModel build() => const CircuitsPageViewModel.loading();

  /// Текущий ViewModel.
  CircuitsPageViewModel get viewModel => state;

  /// Заменяет ViewModel.
  void setViewModel(CircuitsPageViewModel value) => state = value;
}
