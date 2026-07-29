import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_round_score.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';

/// Метрики + очки по раундам для одного участника H2H.
class H2hEntityCompareData {
  const H2hEntityCompareData({
    required this.stats,
    required this.scores,
  });

  final H2hStats stats;
  final List<H2hRoundScore> scores;
}

/// Готовый результат сравнения двух участников (stats + timeline).
class H2hLoadedCompare {
  const H2hLoadedCompare({
    required this.statsA,
    required this.statsB,
    required this.timeline,
  });

  final H2hStats statsA;
  final H2hStats statsB;
  final H2hPointsTimeline timeline;
}
