import 'package:f1_pet_project/core/results/hall_of_fame/state/state_models/hall_of_fame_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [HallOfFamePageViewModel] для экрана «Зал славы».
class HallOfFamePageStateHolder extends Notifier<HallOfFamePageViewModel> {
  @override
  HallOfFamePageViewModel build() => const HallOfFamePageViewModel();

  HallOfFamePageViewModel get viewModel => state;

  void setViewModel(HallOfFamePageViewModel value) => state = value;
}
