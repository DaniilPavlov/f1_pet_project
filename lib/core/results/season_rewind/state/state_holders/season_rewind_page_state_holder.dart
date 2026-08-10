import 'package:f1_pet_project/core/results/season_rewind/state/state_models/season_rewind_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [SeasonRewindPageViewModel] для экрана перемотки сезона.
class SeasonRewindPageStateHolder extends Notifier<SeasonRewindPageViewModel> {
  @override
  SeasonRewindPageViewModel build() => const SeasonRewindPageViewModel();

  SeasonRewindPageViewModel get viewModel => state;

  void setViewModel(SeasonRewindPageViewModel value) => state = value;
}
