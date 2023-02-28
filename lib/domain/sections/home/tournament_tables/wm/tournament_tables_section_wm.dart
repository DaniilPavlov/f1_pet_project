import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/wm/tournament_tables_section_model.dart';
import 'package:f1_pet_project/presentation/sections/home/tournament_tables/tournament_tables_section.dart';
import 'package:flutter/cupertino.dart';

class TournamentTablesSectionWM
    extends WidgetModel<TournamentTableSection, TournamentTablesSectionModel> {
  final _activePage = StateNotifier<int>(initValue: 0);

  ListenableState<int> get activePage => _activePage;
  TournamentTablesSectionWM(super.model);

  void changeActivePage({required int value}) {
    _activePage.accept(value);
  }
}

TournamentTablesSectionWM createTournamentTableSectionWM(BuildContext _) =>
    TournamentTablesSectionWM(TournamentTablesSectionModel());
