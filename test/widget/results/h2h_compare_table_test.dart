import 'package:f1_pet_project/core/results/h2h/components/h2h_compare_table.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_round_score.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('H2hCompareTable', () {
    testWidgets('shows driver names and metric rows', (tester) async {
      final timeline = H2hPointsTimeline.fromScores(
        scoresA: const [H2hRoundScore(season: '2024', round: '1', raceName: 'Bahrain', points: 25)],
        scoresB: const [H2hRoundScore(season: '2024', round: '1', raceName: 'Bahrain', points: 18)],
      );

      await tester.pumpApp(
        SingleChildScrollView(
          child: H2hCompareTable(
            nameA: 'Max',
            nameB: 'Charles',
            statsA: const H2hStats(races: 10, wins: 5, podiums: 7, poles: 3),
            statsB: const H2hStats(races: 10, wins: 2, podiums: 4, poles: 1),
            timeline: timeline,
            season: '2024',
          ),
        ),
      );

      expect(find.text('Max'), findsWidgets);
      expect(find.text('Charles'), findsWidgets);
      expect(find.text('5'), findsWidgets);
      expect(find.text('2'), findsWidgets);
    });

    testWidgets('shows empty timeline copy and fractional points label', (tester) async {
      final timeline = H2hPointsTimeline.fromScores(
        scoresA: const [H2hRoundScore(season: '2024', round: '1', raceName: 'Bahrain', points: 12.5)],
        scoresB: const [H2hRoundScore(season: '2024', round: '1', raceName: 'Bahrain', points: 8)],
      );

      await tester.pumpApp(
        SingleChildScrollView(
          child: Column(
            children: [
              const H2hCompareTable(
                nameA: 'A',
                nameB: 'B',
                statsA: H2hStats(races: 1, wins: 0, podiums: 0, poles: 0),
                statsB: H2hStats(races: 1, wins: 0, podiums: 0, poles: 0),
                timeline: H2hPointsTimeline(points: []),
              ),
              H2hCompareTable(
                nameA: 'A',
                nameB: 'B',
                statsA: const H2hStats(races: 1, wins: 0, podiums: 1, poles: 0),
                statsB: const H2hStats(races: 1, wins: 0, podiums: 0, poles: 0),
                timeline: timeline,
              ),
            ],
          ),
        ),
      );

      expect(find.text(AppLocalizationsEn().h2hPointsTimelineEmpty), findsOneWidget);
      expect(find.textContaining('12.5'), findsWidgets);
    });

    testWidgets('golden with constructor team colors', (tester) async {
      final timeline = H2hPointsTimeline.fromScores(
        scoresA: const [
          H2hRoundScore(season: '2024', round: '1', raceName: 'Bahrain', points: 25),
          H2hRoundScore(season: '2024', round: '2', raceName: 'Saudi', points: 18),
        ],
        scoresB: const [
          H2hRoundScore(season: '2024', round: '1', raceName: 'Bahrain', points: 18),
          H2hRoundScore(season: '2024', round: '2', raceName: 'Saudi', points: 25),
        ],
      );

      await tester.pumpApp(
        ColoredBox(
          color: Colors.white,
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: H2hCompareTable(
                nameA: 'Max',
                nameB: 'Charles',
                statsA: const H2hStats(races: 10, wins: 5, podiums: 7, poles: 3),
                statsB: const H2hStats(races: 10, wins: 2, podiums: 4, poles: 1),
                timeline: timeline,
                season: '2024',
                constructorIdA: 'red_bull',
                constructorIdB: 'ferrari',
              ),
            ),
          ),
        ),
        surfaceSize: const Size(390, 520),
      );
      await tester.pumpForGolden();

      await expectLater(
        find.byType(H2hCompareTable),
        matchesGoldenFile('../goldens/h2h_compare_table.png'),
      );
    });
  });
}
