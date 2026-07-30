import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/widgets/share/share_career_card.dart';
import 'package:f1_pet_project/common/widgets/share/share_race_results_card.dart';
import 'package:f1_pet_project/common/widgets/share/share_weekend_summary_card.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('ShareCareerCard', () {
    testWidgets('shows title and career totals', (tester) async {
      await tester.pumpApp(
        ShareCareerCard(
          l10n: l10n,
          title: 'Max Verstappen',
          stats: const CareerStats<Object>(
            races: 200,
            wins: 60,
            podiums: 110,
            poles: 40,
            current: [],
            related: [],
          ),
        ),
      );

      expect(find.text('Max Verstappen'), findsOneWidget);
      expect(find.text('200'), findsOneWidget);
      expect(find.text('60'), findsOneWidget);
    });
  });

  group('ShareRaceResultsCard', () {
    testWidgets('lists race results', (tester) async {
      await tester.pumpApp(
        ShareRaceResultsCard(l10n: l10n, race: ControllerFixtures.race),
      );

      expect(find.text('Monaco Grand Prix'), findsOneWidget);
      expect(find.textContaining('Verstappen'), findsOneWidget);
    });

    testWidgets('shows empty copy when no results', (tester) async {
      final base = ControllerFixtures.race;
      final race = RacesModel(
        season: base.season,
        round: base.round,
        url: base.url,
        raceName: base.raceName,
        circuit: base.circuit,
        date: base.date,
        time: base.time,
        firstPractice: base.firstPractice,
        secondPractice: base.secondPractice,
        thirdPractice: base.thirdPractice,
        qualifying: base.qualifying,
        sprint: base.sprint,
        results: null,
        qualifyingResults: null,
        pitStops: null,
      );

      await tester.pumpApp(
        ShareRaceResultsCard(l10n: l10n, race: race),
      );

      expect(find.text(l10n.shareNoResults), findsOneWidget);
    });
  });

  group('ShareWeekendSummaryCard', () {
    testWidgets('shows sessions and podium', (tester) async {
      const event = EspnScoreboardEvent(
        name: 'Monaco Grand Prix',
        shortName: 'MON',
        statusState: 'post',
        statusDetail: 'Final',
        circuitName: 'Circuit de Monaco',
        circuitCity: 'Monte Carlo',
        circuitCountry: 'Monaco',
        sessions: [
          EspnScoreboardSession(
            abbreviation: 'Q',
            statusState: 'post',
            statusDetail: 'Final',
            leaderName: 'Charles Leclerc',
            isWinner: true,
          ),
          EspnScoreboardSession(
            abbreviation: 'Race',
            statusState: 'post',
            statusDetail: 'Final',
            leaderName: 'Max Verstappen',
            isWinner: true,
            results: [
              EspnScoreboardResultEntry(position: 1, displayName: 'Max Verstappen', isWinner: true),
              EspnScoreboardResultEntry(position: 2, displayName: 'Charles Leclerc'),
              EspnScoreboardResultEntry(position: 3, displayName: 'Lando Norris'),
            ],
          ),
        ],
      );

      await tester.pumpApp(
        ShareWeekendSummaryCard(l10n: l10n, event: event, locale: const Locale('en')),
      );

      expect(find.text('MON'), findsOneWidget);
      expect(find.text('Circuit de Monaco'), findsOneWidget);
      expect(find.text(l10n.shareWeekendPodium), findsOneWidget);
      expect(find.text('Max Verstappen'), findsWidgets);
      expect(find.text('Lando Norris'), findsOneWidget);
    });
  });
}
