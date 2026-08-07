import 'package:f1_pet_project/core/home/controllers/tournament_tables_section_controller/tournament_tables_section_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TournamentTablesSectionController', () {
    test('starts with drivers table active', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(tournamentTablesSectionControllerProvider).activeTable, 0);
    });

    test('changes active table', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(tournamentTablesSectionControllerProvider.notifier).changeActiveTable(1);

      expect(container.read(tournamentTablesSectionControllerProvider).activeTable, 1);
    });
  });
}
