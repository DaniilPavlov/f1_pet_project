import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/wm/tournament_tables_section_model.dart';
import 'package:f1_pet_project/presentation/sections/home/sections/tournament_tables/tournament_tables_section.dart';
import 'package:flutter/cupertino.dart';

class TournamentTablesSectionWM
    extends WidgetModel<TournamentTablesSection, TournamentTablesSectionModel>
    implements ITournamentTablesSectionWM {
  TournamentTablesSectionWM(super._model);
  final _activeTable = StateNotifier<int>(initValue: 0);

  @override
  ListenableState<int> get activeTable => _activeTable;

  @override
  void changeActiveTable({required int value}) {
    _activeTable.accept(value);
  }
}

TournamentTablesSectionWM createTournamentTableSectionWM(BuildContext _) =>
    TournamentTablesSectionWM(TournamentTablesSectionModel());

abstract interface class ITournamentTablesSectionWM implements IWidgetModel {
  /// Returns active table id.
  ListenableState<int> get activeTable;

  /// Changes active table.
  void changeActiveTable({required int value});
}
