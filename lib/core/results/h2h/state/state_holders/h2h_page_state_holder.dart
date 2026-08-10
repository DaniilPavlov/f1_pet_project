import 'package:f1_pet_project/core/results/h2h/models/h2h_mode.dart';
import 'package:f1_pet_project/core/results/h2h/state/state_models/h2h_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [H2hPageViewModel] для экрана H2H.
class H2hPageStateHolder extends Notifier<H2hPageViewModel> {
  H2hPageStateHolder(this.initialMode);

  /// Режим (пилоты или команды) при открытии экрана.
  final H2hMode initialMode;

  @override
  H2hPageViewModel build() => H2hPageViewModel(mode: initialMode);

  H2hPageViewModel get viewModel => state;

  void setViewModel(H2hPageViewModel value) => state = value;
}
