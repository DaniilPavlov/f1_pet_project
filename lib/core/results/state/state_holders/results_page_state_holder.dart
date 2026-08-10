import 'package:f1_pet_project/core/results/state/state_models/results_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [ResultsPageViewModel] для экрана результатов.
class ResultsPageStateHolder extends Notifier<ResultsPageViewModel> {
  @override
  ResultsPageViewModel build() => const ResultsPageViewModel();

  ResultsPageViewModel get viewModel => state;

  void setViewModel(ResultsPageViewModel value) => state = value;
}
