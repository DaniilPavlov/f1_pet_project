import 'package:f1_pet_project/core/results/constructor/state/state_models/constructor_page_args.dart';
import 'package:f1_pet_project/core/results/constructor/state/state_models/constructor_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [ConstructorPageViewModel] для экрана конструктора.
class ConstructorPageStateHolder extends Notifier<ConstructorPageViewModel> {
  ConstructorPageStateHolder(this.args);

  /// Аргументы с данными конструктора.
  final ConstructorPageArgs args;

  @override
  ConstructorPageViewModel build() => const ConstructorPageViewModel();

  ConstructorPageViewModel get viewModel => state;

  void setViewModel(ConstructorPageViewModel value) => state = value;
}
