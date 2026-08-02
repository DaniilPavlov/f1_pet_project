import 'package:f1_pet_project/core/predictor/models/predictor_season.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';

/// Агрегат всех сезонов предиктора в памяти (Firestore хранит по сезонам).
class PredictorStore {
  const PredictorStore({required this.seasons});

  factory PredictorStore.empty() => const PredictorStore(seasons: {});

  /// Разбор единого JSON (тесты / legacy); runtime грузит сезоны по одному.
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

  /// Сезон по году или `null`.
  PredictorSeason? season(String year) => seasons[year];

  /// Уикенд сезона по round или `null`.
  PredictorWeekendPrediction? weekend({required String year, required String round}) {
    return seasons[year]?.weekends[round];
  }

  /// Иммутабельно вставляет/заменяет уикенд в сезоне.
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
