import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_round_score.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('H2hPointsTimeline.fromScores', () {
    test('builds cumulative points aligned by season+round', () {
      const a = [
        H2hRoundScore(season: '2024', round: '1', raceName: 'Bahrain', points: 25),
        H2hRoundScore(season: '2024', round: '2', raceName: 'Saudi', points: 18),
        H2hRoundScore(season: '2024', round: '3', raceName: 'Australia', points: 15),
      ];
      const b = [
        H2hRoundScore(season: '2024', round: '1', raceName: 'Bahrain', points: 18),
        H2hRoundScore(season: '2024', round: '2', raceName: 'Saudi', points: 25),
        H2hRoundScore(season: '2024', round: '3', raceName: 'Australia', points: 12),
      ];

      final timeline = H2hPointsTimeline.fromScores(
        scoresA: a,
        scoresB: b,
        seasonScope: '2024',
      );

      expect(timeline.points, hasLength(3));
      expect(timeline.points[0].label, '1');
      expect(timeline.points[0].cumulativeA, 25);
      expect(timeline.points[0].cumulativeB, 18);
      expect(timeline.points[1].cumulativeA, 43);
      expect(timeline.points[1].cumulativeB, 43);
      expect(timeline.points[2].cumulativeA, 58);
      expect(timeline.points[2].cumulativeB, 55);
      expect(timeline.maxCumulative, 58);
    });

    test('fills missing rounds with zero and carries cumulative', () {
      const a = [
        H2hRoundScore(season: '2024', round: '1', raceName: 'Bahrain', points: 25),
        H2hRoundScore(season: '2024', round: '3', raceName: 'Australia', points: 25),
      ];
      const b = [
        H2hRoundScore(season: '2024', round: '2', raceName: 'Saudi', points: 25),
      ];

      final timeline = H2hPointsTimeline.fromScores(scoresA: a, scoresB: b);

      expect(timeline.points, hasLength(3));
      expect(timeline.points[0].cumulativeA, 25);
      expect(timeline.points[0].cumulativeB, 0);
      expect(timeline.points[1].cumulativeA, 25);
      expect(timeline.points[1].cumulativeB, 25);
      expect(timeline.points[2].cumulativeA, 50);
      expect(timeline.points[2].cumulativeB, 25);
      expect(timeline.points[0].label, '2024 · R1');
    });

    test('merges sprint points already summed into round score', () {
      const a = [
        H2hRoundScore(season: '2024', round: '5', raceName: 'China', points: 33),
      ];
      const b = [
        H2hRoundScore(season: '2024', round: '5', raceName: 'China', points: 19),
      ];

      final timeline = H2hPointsTimeline.fromScores(
        scoresA: a,
        scoresB: b,
        seasonScope: '2024',
      );

      expect(timeline.points.single.cumulativeA, 33);
      expect(timeline.points.single.roundPointsA, 33);
    });
  });
}
