import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/wm/hof_tournament_tables_section_model.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/sections/hof_tournament_tables_section.dart';
import 'package:flutter/cupertino.dart';

class HofTournamentTablesSectionWM extends WidgetModel<HofTournamentTablesSection, HofTournamentTablesSectionModel>
    implements ITournamentTablesSectionWM {
  HofTournamentTablesSectionWM(super._model);
  final _activeTable = StateNotifier<int>(initValue: 0);

  @override
  ListenableState<int> get activeTable => _activeTable;

  @override
  void changeActiveTable(int value) {
    _activeTable.accept(value);
  }
}

HofTournamentTablesSectionWM createHofTournamentTableSectionWM(BuildContext _) =>
    HofTournamentTablesSectionWM(HofTournamentTablesSectionModel());

abstract interface class ITournamentTablesSectionWM implements IWidgetModel {
  /// Returns active table id.
  ListenableState<int> get activeTable;

  /// Changes active table.
  void changeActiveTable(int value);
}
