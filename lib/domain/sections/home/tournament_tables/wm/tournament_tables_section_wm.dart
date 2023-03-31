import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/wm/tournament_tables_section_model.dart';
import 'package:f1_pet_project/presentation/sections/home/sections/tournament_tables/tournament_tables_section.dart';
import 'package:flutter/cupertino.dart';

class TournamentTablesSectionWM
    extends WidgetModel<TournamentTablesSection, TournamentTablesSectionModel>
    implements ITournamentTablesSectionWM {
  final _activeTable = StateNotifier<int>(initValue: 0);

  @override
  ListenableState<int> get activeTable => _activeTable;

  TournamentTablesSectionWM(super.model);

  @override
  void changeActiveTable({required int value}) {
    _activeTable.accept(value);
  }
}

TournamentTablesSectionWM createTournamentTableSectionWM(BuildContext _) =>
    TournamentTablesSectionWM(TournamentTablesSectionModel());

abstract class ITournamentTablesSectionWM extends IWidgetModel {
  /// Returns active table id.
  ListenableState<int> get activeTable;

  /// Changes active table.
  void changeActiveTable({required int value});
}
