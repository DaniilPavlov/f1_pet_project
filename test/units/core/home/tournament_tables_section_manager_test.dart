import 'package:f1_pet_project/core/home/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TournamentTablesSectionManager', () {
    test('starts with drivers table active', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(tournamentTablesSectionStateHolderProvider).activeTable, 0);
    });

    test('changes active table', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(tournamentTablesSectionManagerProvider).changeActiveTable(1);

      expect(container.read(tournamentTablesSectionStateHolderProvider).activeTable, 1);
    });
  });
}
