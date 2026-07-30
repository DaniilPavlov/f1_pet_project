import 'package:f1_pet_project/core/results/components/race_info_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/widget_fixtures.dart';

void main() {
  group('RaceInfoTable', () {
    testWidgets('renders race result rows', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: RaceInfoTable(raceModel: WidgetFixtures.race),
        ),
      );

      expect(find.textContaining('Verstappen'), findsOneWidget);
      expect(find.textContaining('Norris'), findsOneWidget);
      expect(find.text('Red Bull'), findsOneWidget);
      expect(find.text('Ferrari'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
      expect(find.text('18'), findsOneWidget);
    });

    testWidgets('shows detailed info affordance when rows are limited', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: RaceInfoTable(raceModel: WidgetFixtures.race, rowsNumber: 1),
        ),
      );

      expect(find.text('Detailed information'), findsOneWidget);
      expect(find.textContaining('Verstappen'), findsOneWidget);
      expect(find.textContaining('Norris'), findsNothing);
    });

    testWidgets('golden', (tester) async {
      await tester.pumpApp(
        ColoredBox(
          color: Colors.white,
          child: Align(
            alignment: Alignment.topCenter,
            child: RaceInfoTable(raceModel: WidgetFixtures.race),
          ),
        ),
        surfaceSize: const Size(390, 220),
      );
      await tester.pumpForGolden();

      await expectLater(find.byType(RaceInfoTable), matchesGoldenFile('../goldens/race_info_table.png'));
    });
  });
}
