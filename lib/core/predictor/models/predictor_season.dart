import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';

/// Предсказания пользователя за один календарный сезон F1.
class PredictorSeason {
  const PredictorSeason({required this.year, required this.weekends});

  factory PredictorSeason.fromJson(String year, Map<String, dynamic> json) {
    final rawWeekends = json['weekends'];
    final weekends = <String, PredictorWeekendPrediction>{};
    if (rawWeekends is Map<String, dynamic>) {
      for (final entry in rawWeekends.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          weekends[entry.key] = PredictorWeekendPrediction.fromJson(value);
        }
      }
    }
    return PredictorSeason(year: year, weekends: weekends);
  }

  final String year;
  final Map<String, PredictorWeekendPrediction> weekends;

  int get totalPoints => weekends.values.fold(0, (sum, w) => sum + w.totalPoints);

  List<PredictorWeekendPrediction> get weekendsSorted {
    final list = weekends.values.toList()
      ..sort((a, b) {
        final ar = int.tryParse(a.round) ?? 0;
        final br = int.tryParse(b.round) ?? 0;
        return ar.compareTo(br);
      });
    return list;
  }

  PredictorSeason upsertWeekend(PredictorWeekendPrediction weekend) {
    return PredictorSeason(
      year: year,
      weekends: {...weekends, weekend.round: weekend},
    );
  }

  Map<String, dynamic> toJson() => {
    'weekends': {for (final e in weekends.entries) e.key: e.value.toJson()},
  };
}
