import 'package:f1_pet_project/common/widgets/tables/tournament_constructors_table.dart';
import 'package:f1_pet_project/common/widgets/tables/tournament_drivers_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/widget_fixtures.dart';

void main() {
  group('TournamentDriversTable', () {
    testWidgets('renders standings rows', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: TournamentDriversTable(drivers: WidgetFixtures.driversStandings),
        ),
      );

      expect(find.textContaining('Verstappen'), findsOneWidget);
      expect(find.textContaining('Norris'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('80'), findsOneWidget);
      expect(find.text('Red Bull'), findsOneWidget);
      expect(find.text('Ferrari'), findsOneWidget);
    });

    testWidgets('golden', (tester) async {
      await tester.pumpApp(
        ColoredBox(
          color: Colors.white,
          child: Align(
            alignment: Alignment.topCenter,
            child: TournamentDriversTable(drivers: WidgetFixtures.driversStandings),
          ),
        ),
        surfaceSize: const Size(390, 220),
      );
      await tester.pumpForGolden();

      await expectLater(
        find.byType(TournamentDriversTable),
        matchesGoldenFile('../goldens/tournament_drivers_table.png'),
      );
    });
  });

  group('TournamentConstructorsTable', () {
    testWidgets('renders standings rows', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: TournamentConstructorsTable(constructors: WidgetFixtures.constructorsStandings),
        ),
      );

      expect(find.text('Red Bull'), findsOneWidget);
      expect(find.text('Ferrari'), findsOneWidget);
      expect(find.text('200'), findsOneWidget);
      expect(find.text('150'), findsOneWidget);
    });

    testWidgets('golden', (tester) async {
      await tester.pumpApp(
        ColoredBox(
          color: Colors.white,
          child: Align(
            alignment: Alignment.topCenter,
            child: TournamentConstructorsTable(constructors: WidgetFixtures.constructorsStandings),
          ),
        ),
        surfaceSize: const Size(390, 200),
      );
      await tester.pumpForGolden();

      await expectLater(
        find.byType(TournamentConstructorsTable),
        matchesGoldenFile('../goldens/tournament_constructors_table.png'),
      );
    });
  });
}
