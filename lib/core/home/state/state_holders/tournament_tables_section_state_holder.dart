import 'package:f1_pet_project/core/home/state/state_models/tournament_tables_section_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит [TournamentTablesSectionViewModel] для секции турнирных таблиц.
class TournamentTablesSectionStateHolder extends Notifier<TournamentTablesSectionViewModel> {
  @override
  TournamentTablesSectionViewModel build() => const TournamentTablesSectionViewModel();

  TournamentTablesSectionViewModel get viewModel => state;

  void setViewModel(TournamentTablesSectionViewModel value) => state = value;
}
