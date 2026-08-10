import 'package:f1_pet_project/core/results/race_search/state/state_models/race_search_page_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [RaceSearchPageViewModel] для экрана поиска гонки.
class RaceSearchPageStateHolder extends Notifier<RaceSearchPageViewModel> {
  RaceSearchPageStateHolder(this.languageCode);

  /// Код языка для локализации в поиске.
  final String languageCode;

  @override
  RaceSearchPageViewModel build() => const RaceSearchPageViewModel();

  RaceSearchPageViewModel get viewModel => state;

  void setViewModel(RaceSearchPageViewModel value) => state = value;
}
