import 'package:f1_pet_project/core/home/state/state_holders/tournament_tables_section_state_holder.dart';

/// Переключает активную таблицу между пилотами и конструкторами.
class TournamentTablesSectionManager {
  TournamentTablesSectionManager({
    required TournamentTablesSectionStateHolder holder,
  }) : _holder = holder;

  final TournamentTablesSectionStateHolder _holder;

  /// Устанавливает индекс отображаемой таблицы.
  void changeActiveTable(int value) {
    _holder.setViewModel(_holder.viewModel.copyWith(activeTable: value));
  }
}
