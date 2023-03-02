import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/wm/tournament_tables_section_model.dart';
import 'package:f1_pet_project/presentation/sections/home/sections/tournament_tables/tournament_tables_section.dart';
import 'package:flutter/cupertino.dart';

abstract class ITournamentTablesSectionWM extends IWidgetModel {
  /// активная таблица
  ListenableState<int> get activeTable;

  /// сменить таблицу
  void changeActivePage({required int value});
}

class TournamentTablesSectionWM
    extends WidgetModel<TournamentTableSection, TournamentTablesSectionModel>
    implements ITournamentTablesSectionWM {
  final _activeTable = StateNotifier<int>(initValue: 0);

  @override
  ListenableState<int> get activeTable => _activeTable;

  TournamentTablesSectionWM(super.model);

  @override
  void changeActivePage({required int value}) {
    _activeTable.accept(value);
  }
}

TournamentTablesSectionWM createTournamentTableSectionWM(BuildContext _) =>
    TournamentTablesSectionWM(TournamentTablesSectionModel());
