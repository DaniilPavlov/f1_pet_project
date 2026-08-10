import 'package:f1_pet_project/core/predictor/state/state_models/predictor_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [PredictorPageViewModel] для экрана предиктора.
class PredictorPageStateHolder extends Notifier<PredictorPageViewModel> {
  @override
  PredictorPageViewModel build() => PredictorPageViewModel(now: DateTime.now());

  PredictorPageViewModel get viewModel => state;

  void setViewModel(PredictorPageViewModel value) => state = value;
}
