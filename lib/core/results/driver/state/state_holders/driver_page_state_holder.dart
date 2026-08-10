import 'package:f1_pet_project/core/results/driver/state/state_models/driver_page_args.dart';
import 'package:f1_pet_project/core/results/driver/state/state_models/driver_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [DriverPageViewModel] для экрана пилота.
class DriverPageStateHolder extends Notifier<DriverPageViewModel> {
  DriverPageStateHolder(this.args);

  /// Аргументы с данными пилота.
  final DriverPageArgs args;

  @override
  DriverPageViewModel build() => const DriverPageViewModel();

  DriverPageViewModel get viewModel => state;

  void setViewModel(DriverPageViewModel value) => state = value;
}
