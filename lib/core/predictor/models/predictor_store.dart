import 'package:f1_pet_project/core/predictor/models/predictor_season.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';

/// Корневой локальный документ предиктора (все сезоны).
class PredictorStore {
  const PredictorStore({required this.seasons});

  factory PredictorStore.empty() => const PredictorStore(seasons: {});

  factory PredictorStore.fromJson(Map<String, dynamic> json) {
    final rawSeasons = json['seasons'];
    final seasons = <String, PredictorSeason>{};
    if (rawSeasons is Map<String, dynamic>) {
      for (final entry in rawSeasons.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          seasons[entry.key] = PredictorSeason.fromJson(entry.key, value);
        }
      }
    }
    return PredictorStore(seasons: seasons);
  }

  final Map<String, PredictorSeason> seasons;

  PredictorSeason? season(String year) => seasons[year];

  PredictorWeekendPrediction? weekend({required String year, required String round}) {
    return seasons[year]?.weekends[round];
  }

  PredictorStore upsertWeekend({
    required String year,
    required PredictorWeekendPrediction weekend,
  }) {
    final existing = seasons[year] ?? PredictorSeason(year: year, weekends: {});
    return PredictorStore(
      seasons: {...seasons, year: existing.upsertWeekend(weekend)},
    );
  }

  Map<String, dynamic> toJson() => {
    'seasons': {for (final e in seasons.entries) e.key: e.value.toJson()},
  };
}
