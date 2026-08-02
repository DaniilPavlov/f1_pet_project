import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';

/// Strategy (статический scoring): 1 очко за точное совпадение места.
abstract final class PredictorScoreService {
  /// Сравнивает предсказанный порядок с фактическим (индекс 0 = 1 место).
  static int scoreOrders({
    required List<String> predicted,
    required List<String> actualByPosition,
  }) {
    var points = 0;
    final length = predicted.length < actualByPosition.length ? predicted.length : actualByPosition.length;
    for (var i = 0; i < length; i++) {
      if (predicted[i] == actualByPosition[i]) {
        points++;
      }
    }
    return points;
  }

  /// driverId по возрастанию position из квалификации.
  static List<String> qualifyingActualOrder(List<QualifyingResultsModel> results) {
    final sorted = [...results]
      ..sort((a, b) {
        final ap = int.tryParse(a.position) ?? 999;
        final bp = int.tryParse(b.position) ?? 999;
        return ap.compareTo(bp);
      });
    return sorted.map((r) => r.driver.driverId).toList();
  }

  /// driverId по возрастанию финишной position (только classified).
  static List<String> raceActualOrder(List<ResultsModel> results) {
    final classified = results.where((r) => r.isClassified).toList()
      ..sort((a, b) {
        final ap = int.tryParse(a.position) ?? 999;
        final bp = int.tryParse(b.position) ?? 999;
        return ap.compareTo(bp);
      });
    return classified.map((r) => r.driver.driverId).toList();
  }

  /// Обновляет очки уикенда по доступным результатам (пересчёт из предикта).
  ///
  /// Также кэширует [PredictorWeekendPrediction.actualQualifyingOrder] /
  /// [PredictorWeekendPrediction.actualRaceOrder].
  static PredictorWeekendPrediction applyResults({
    required PredictorWeekendPrediction weekend,
    List<QualifyingResultsModel>? qualifyingResults,
    List<ResultsModel>? raceResults,
    List<String>? actualQualifyingOrder,
    List<String>? actualRaceOrder,
    DateTime? now,
  }) {
    var next = weekend;
    final scoredAt = now ?? DateTime.now();

    final qualiActual =
        actualQualifyingOrder ??
        (qualifyingResults != null && qualifyingResults.isNotEmpty
            ? qualifyingActualOrder(qualifyingResults)
            : null);
    if (qualiActual != null && qualiActual.isNotEmpty) {
      next = next.copyWith(
        qualiPoints: scoreOrders(predicted: weekend.qualifyingOrder, actualByPosition: qualiActual),
        actualQualifyingOrder: qualiActual,
        scoredAt: scoredAt,
      );
    }

    final raceActual =
        actualRaceOrder ??
        (raceResults != null && raceResults.isNotEmpty ? raceActualOrder(raceResults) : null);
    if (raceActual != null && raceActual.isNotEmpty) {
      next = next.copyWith(
        racePoints: scoreOrders(predicted: weekend.raceOrder, actualByPosition: raceActual),
        actualRaceOrder: raceActual,
        scoredAt: scoredAt,
      );
    }

    return next;
  }
}
