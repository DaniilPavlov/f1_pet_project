// ignore_for_file: avoid_implementing_value_types

import 'package:elementary/elementary.dart';
import 'package:elementary_test/elementary_test.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/wm/tournament_tables_section_model.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/wm/tournament_tables_section_wm.dart';
import 'package:f1_pet_project/presentation/sections/home/sections/tournament_tables/tournament_tables_section.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Tests for [TournamentTablesSectionWM].
void main() {
  late TournamentTableSectionModelMock model;

  TournamentTablesSectionWM setUpWm() {
    model = TournamentTableSectionModelMock();

    return TournamentTablesSectionWM(model);
  }

  testWidgetModel<TournamentTablesSectionWM, TournamentTablesSection>(
    'check that tables changes',
    setUpWm,
    (wm, tester, context) async {
      tester.init();
      wm.changeActiveTable(value: 1);
      Future.delayed(const Duration(milliseconds: 30), () {});
      final value = wm.activeTable.value;
      expect(value, 1);
    },
  );
}

class TournamentTableSectionModelMock extends Mock
    with MockElementaryModelMixin
    implements TournamentTablesSectionModel {}
