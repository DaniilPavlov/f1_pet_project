import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:flutter/foundation.dart';

/// Аргументы семейства экрана сравнения уикенда.
@immutable
class PredictorWeekendDetailPageArgs {
  const PredictorWeekendDetailPageArgs({required this.season, required this.weekend});

  final String season;
  final PredictorWeekendPrediction weekend;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PredictorWeekendDetailPageArgs &&
          season == other.season &&
          weekend.round == other.weekend.round;

  @override
  int get hashCode => Object.hash(season, weekend.round);
}
