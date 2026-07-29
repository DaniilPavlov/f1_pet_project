import 'package:f1_pet_project/core/results/h2h/components/h2h_filters_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('H2hFiltersCard', () {
    testWidgets('career scope shows entity filter only', (tester) async {
      final year = TextEditingController(text: '2024');
      addTearDown(year.dispose);

      await tester.pumpApp(
        SingleChildScrollView(
          child: H2hFiltersCard(
            scopeMode: 0,
            useCurrentSeason: true,
            currentEntitiesOnly: true,
            isSeasonScope: false,
            showYearPicker: false,
            latestSeason: '2024',
            yearController: year,
            entitiesFilterLabel: 'Drivers',
            currentEntitiesTitle: 'Current drivers',
            allEntitiesTitle: 'All drivers',
            onScopeModeChanged: (_) {},
            onUseCurrentSeasonChanged: (_) {},
            onCurrentEntitiesOnlyChanged: (_) {},
            onSeasonChanged: () {},
          ),
        ),
      );

      expect(find.text('Drivers'), findsOneWidget);
      expect(find.text('Current drivers'), findsOneWidget);
      expect(find.text('All drivers'), findsOneWidget);
      expect(find.text('Pick year'), findsNothing);
    });

    testWidgets('season scope shows season filter and latest season label', (tester) async {
      var useCurrent = true;
      final year = TextEditingController(text: '2024');
      addTearDown(year.dispose);

      await tester.pumpApp(
        SingleChildScrollView(
          child: H2hFiltersCard(
            scopeMode: 1,
            useCurrentSeason: useCurrent,
            currentEntitiesOnly: true,
            isSeasonScope: true,
            showYearPicker: false,
            latestSeason: '2025',
            yearController: year,
            entitiesFilterLabel: 'Drivers',
            currentEntitiesTitle: 'Current drivers',
            allEntitiesTitle: 'All drivers',
            onScopeModeChanged: (_) {},
            onUseCurrentSeasonChanged: (v) => useCurrent = v,
            onCurrentEntitiesOnlyChanged: (_) {},
            onSeasonChanged: () {},
          ),
        ),
      );

      expect(find.text('Pick year'), findsOneWidget);
      expect(find.textContaining('2025'), findsOneWidget);

      await tester.tap(find.text('Pick year'));
      await tester.pump();
      expect(useCurrent, isFalse);
    });
  });
}
