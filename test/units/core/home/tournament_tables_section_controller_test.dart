import 'package:f1_pet_project/core/home/controllers/tournament_tables_section_controller/tournament_tables_section_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mobx/mobx_testing.dart';

void main() {
  group('TournamentTablesSectionController', () {
    mobxTest(
      'starts with drivers table active',
      build: TournamentTablesSectionController.new,
      value: (store) => store.activeTable,
      expect: () => [0],
    );

    mobxTest(
      'changes active table',
      build: TournamentTablesSectionController.new,
      value: (store) => store.activeTable,
      act: (store) => store.changeActiveTable(1),
      expect: () => [0, 1],
    );
  });
}
