import 'package:f1_pet_project/core/predictor/state/state_models/predictor_weekend_detail_page_args.dart';
import 'package:f1_pet_project/core/predictor/state/state_models/predictor_weekend_detail_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [PredictorWeekendDetailPageViewModel] для экрана сравнения уикенда.
class PredictorWeekendDetailPageStateHolder extends Notifier<PredictorWeekendDetailPageViewModel> {
  PredictorWeekendDetailPageStateHolder(this.args);

  /// Аргументы с сезоном и уикендом для сравнения.
  final PredictorWeekendDetailPageArgs args;

  @override
  PredictorWeekendDetailPageViewModel build() => const PredictorWeekendDetailPageViewModel();

  PredictorWeekendDetailPageViewModel get viewModel => state;

  void setViewModel(PredictorWeekendDetailPageViewModel value) => state = value;
}
