import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/core/results/components/weekend_session_results_sheet.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('WeekendSessionResultsSheet', () {
    testWidgets('shows empty copy when session has no results', (tester) async {
      await tester.pumpApp(
        SizedBox(
          height: 500,
          child: WeekendSessionResultsSheet(
            session: const EspnScoreboardSession(
              abbreviation: 'Q',
              statusState: 'post',
              statusDetail: 'Final',
            ),
          ),
        ),
      );

      expect(find.text(AppLocalizationsEn().weekendSessionResultsEmpty), findsOneWidget);
      expect(find.text('Final'), findsNothing);
    });

    testWidgets('shows device-local session date when available', (tester) async {
      await tester.pumpApp(
        SizedBox(
          height: 500,
          child: WeekendSessionResultsSheet(
            session: EspnScoreboardSession(
              abbreviation: 'Q',
              statusState: 'pre',
              statusDetail: '8/21 - 6:30 AM EDT',
              date: DateTime(2024, 8, 21, 14, 30),
            ),
          ),
        ),
      );

      expect(find.textContaining('EDT'), findsNothing);
      expect(find.textContaining('14:30'), findsOneWidget);
    });

    testWidgets('lists result rows', (tester) async {
      await tester.pumpApp(
        SizedBox(
          height: 500,
          child: WeekendSessionResultsSheet(
            session: const EspnScoreboardSession(
              abbreviation: 'Race',
              statusState: 'post',
              statusDetail: 'Final',
              results: [
                EspnScoreboardResultEntry(position: 1, displayName: 'Max Verstappen', country: 'Dutch', isWinner: true),
                EspnScoreboardResultEntry(position: 2, displayName: 'Charles Leclerc', country: 'Monegasque'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Max Verstappen'), findsOneWidget);
      expect(find.text('Charles Leclerc'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });
  });
}
