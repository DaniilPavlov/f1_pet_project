import 'package:f1_pet_project/common/widgets/tables/tournament_constructors_table.dart';
import 'package:f1_pet_project/common/widgets/tables/tournament_tables_section.dart';
import 'package:f1_pet_project/l10n/app_localizations_ru.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/widget_fixtures.dart';

void main() {
  group('TournamentTablesSection', () {
    testWidgets('shows title, drivers by default, and switches to constructors', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: TournamentTablesSection(
            title: 'Standings',
            season: '2024',
            round: '5',
            driversStandings: WidgetFixtures.driversStandings,
            constructorsStandings: WidgetFixtures.constructorsStandings,
          ),
        ),
        surfaceSize: const Size(800, 1200),
        locale: const Locale('ru'),
        wrapApp: (app) => ProviderScope(child: app),
      );

      expect(find.text('Standings'), findsOneWidget);
      expect(find.textContaining('Verstappen'), findsOneWidget);

      await tester.tap(find.text(AppLocalizationsRu().constructors));
      await tester.pumpAndSettle();

      expect(find.byType(TournamentConstructorsTable), findsOneWidget);
      expect(find.text('Red Bull'), findsOneWidget);
    });
  });
}
