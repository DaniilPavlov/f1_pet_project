import 'package:f1_pet_project/core/results/finish_status/state/state_models/finish_status_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [FinishStatusPageViewModel] для экрана статусов финиша.
class FinishStatusPageStateHolder extends Notifier<FinishStatusPageViewModel> {
  @override
  FinishStatusPageViewModel build() => const FinishStatusPageViewModel();

  FinishStatusPageViewModel get viewModel => state;

  void setViewModel(FinishStatusPageViewModel value) => state = value;
}
