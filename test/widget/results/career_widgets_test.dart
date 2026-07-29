import 'package:f1_pet_project/common/models/career/career_race_result.dart';
import 'package:f1_pet_project/common/widgets/career/career_race_results_sheet.dart';
import 'package:f1_pet_project/common/widgets/career/career_stats_grid.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('CareerStatsGrid', () {
    testWidgets('renders metrics and invokes taps when value > 0', (tester) async {
      var wins = 0;
      var podiums = 0;

      await tester.pumpApp(
        CareerStatsGrid(
          races: 100,
          wins: 20,
          podiums: 40,
          poles: 0,
          onWinsTap: () => wins++,
          onPodiumsTap: () => podiums++,
          onPolesTap: () {},
        ),
      );

      expect(find.text('100'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);
      expect(find.text('40'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);

      await tester.tap(find.text('20'));
      await tester.pump();
      expect(wins, 1);

      await tester.tap(find.text('40'));
      await tester.pump();
      expect(podiums, 1);
    });
  });

  group('showCareerRaceResultsSheet', () {
    testWidgets('shows empty state', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                showCareerRaceResultsSheet(context: context, title: 'Wins', races: const [], showPosition: false),
            child: const Text('open'),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Wins'), findsOneWidget);
      expect(find.text(AppLocalizationsEn().careerRaceListEmpty), findsOneWidget);
    });

    testWidgets('lists races without navigating', (tester) async {
      final races = [
        CareerRaceResult(
          season: '2024',
          round: '8',
          raceName: 'Monaco Grand Prix',
          position: 1,
          constructor: ControllerFixtures.constructor,
          circuit: ControllerFixtures.circuit,
          driver: ControllerFixtures.driver,
        ),
      ];

      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                showCareerRaceResultsSheet(context: context, title: 'Wins', races: races, showPosition: true),
            child: const Text('open'),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Monaco Grand Prix'), findsOneWidget);
      expect(find.textContaining('P1'), findsOneWidget);
      expect(find.textContaining('Verstappen'), findsOneWidget);
    });
  });

  group('CareerRaceResult', () {
    test('entityName prefers driver then constructor', () {
      final withDriver = CareerRaceResult(
        season: '2024',
        round: '1',
        raceName: 'Bahrain',
        position: 1,
        constructor: ControllerFixtures.constructor,
        circuit: ControllerFixtures.circuit,
        driver: ControllerFixtures.driver,
      );
      final withoutDriver = CareerRaceResult(
        season: '2024',
        round: '1',
        raceName: 'Bahrain',
        position: 1,
        constructor: ControllerFixtures.constructor,
        circuit: ControllerFixtures.circuit,
      );

      expect(withDriver.entityName, contains('Verstappen'));
      expect(withoutDriver.entityName, 'Red Bull');
    });
  });
}
