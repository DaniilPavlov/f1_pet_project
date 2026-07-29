import 'package:f1_pet_project/core/results/h2h/models/h2h_round_score.dart';

/// Точка на графике накопленных очков H2H.
class H2hTimelinePoint {
  const H2hTimelinePoint({
    required this.season,
    required this.round,
    required this.label,
    required this.raceName,
    required this.cumulativeA,
    required this.cumulativeB,
    required this.roundPointsA,
    required this.roundPointsB,
  });

  final String season;
  final String round;

  /// Подпись оси X (номер раунда или `год · R#`).
  final String label;
  final String raceName;
  final double cumulativeA;
  final double cumulativeB;
  final double roundPointsA;
  final double roundPointsB;
}

/// Накопленные очки двух участников по раундам.
class H2hPointsTimeline {
  const H2hPointsTimeline({required this.points});

  final List<H2hTimelinePoint> points;

  bool get isEmpty => points.isEmpty;

  double get maxCumulative {
    var max = 0.0;
    for (final p in points) {
      if (p.cumulativeA > max) {
        max = p.cumulativeA;
      }
      if (p.cumulativeB > max) {
        max = p.cumulativeB;
      }
    }
    return max;
  }

  /// Объединяет очки A/B по `(season, round)`, копит сумму слева направо.
  factory H2hPointsTimeline.fromScores({
    required List<H2hRoundScore> scoresA,
    required List<H2hRoundScore> scoresB,
    String? seasonScope,
  }) {
    final mapA = <String, H2hRoundScore>{};
    for (final s in scoresA) {
      mapA[s.key] = s;
    }
    final mapB = <String, H2hRoundScore>{};
    for (final s in scoresB) {
      mapB[s.key] = s;
    }

    final keys = {...mapA.keys, ...mapB.keys}.toList()
      ..sort((a, b) {
        final sa = mapA[a] ?? mapB[a]!;
        final sb = mapA[b] ?? mapB[b]!;
        final seasonCmp = sa.season.compareTo(sb.season);
        if (seasonCmp != 0) {
          return seasonCmp;
        }
        return sa.roundNumber.compareTo(sb.roundNumber);
      });

    final singleSeason = seasonScope != null && seasonScope.trim().isNotEmpty;
    var cumA = 0.0;
    var cumB = 0.0;
    final points = <H2hTimelinePoint>[];

    for (final key in keys) {
      final a = mapA[key];
      final b = mapB[key];
      final sample = a ?? b!;
      final roundA = a?.points ?? 0;
      final roundB = b?.points ?? 0;
      cumA += roundA;
      cumB += roundB;
      points.add(
        H2hTimelinePoint(
          season: sample.season,
          round: sample.round,
          label: singleSeason ? sample.round : '${sample.season} · R${sample.round}',
          raceName: a?.raceName ?? b?.raceName ?? '',
          cumulativeA: cumA,
          cumulativeB: cumB,
          roundPointsA: roundA,
          roundPointsB: roundB,
        ),
      );
    }

    return H2hPointsTimeline(points: List.unmodifiable(points));
  }
}
