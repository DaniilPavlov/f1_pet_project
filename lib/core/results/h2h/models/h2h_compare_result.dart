import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';

/// Результат сравнения двух сущностей (имена для таблицы).
class H2hCompareResult {
  const H2hCompareResult({
    required this.nameA,
    required this.nameB,
    required this.statsA,
    required this.statsB,
    required this.timeline,
    this.season,
    this.constructorIdA,
    this.constructorIdB,
  });

  final String nameA;
  final String nameB;
  final H2hStats statsA;
  final H2hStats statsB;
  final H2hPointsTimeline timeline;

  /// `null` — сравнение за карьеру.
  final String? season;

  /// Jolpica `constructorId` для цвета линии графика (если известен).
  final String? constructorIdA;
  final String? constructorIdB;
}
