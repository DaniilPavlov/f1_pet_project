import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_table/wm/tournament_table_section_model.dart';
import 'package:f1_pet_project/presentation/sections/home/tournament_table/tournament_table_section.dart';

import 'package:flutter/cupertino.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class TournamentTableSectionWM
    extends WidgetModel<TournamentTableSection, TournamentTableSectionModel> {
  TournamentTableSectionWM(super.model);
}

TournamentTableSectionWM createTournamentTableSectionWM(BuildContext _) =>
    TournamentTableSectionWM(TournamentTableSectionModel());
