import 'package:f1_pet_project/core/predictor/models/predictor_season.dart';

/// Краткая сводка по сезону для кнопки в предикторе.
class PredictorSeasonSummary {
  const PredictorSeasonSummary({
    required this.year,
    required this.totalPoints,
    required this.weekendCount,
  });

  factory PredictorSeasonSummary.fromSeason(PredictorSeason season) {
    return PredictorSeasonSummary(
      year: season.year,
      totalPoints: season.totalPoints,
      weekendCount: season.weekends.length,
    );
  }

  final String year;
  final int totalPoints;
  final int weekendCount;
}
