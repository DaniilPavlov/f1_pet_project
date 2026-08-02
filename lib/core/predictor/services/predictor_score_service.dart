import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';

/// Подсчёт очков предиктора: 1 очко за совпадение места.
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
  static PredictorWeekendPrediction applyResults({
    required PredictorWeekendPrediction weekend,
    List<QualifyingResultsModel>? qualifyingResults,
    List<ResultsModel>? raceResults,
    DateTime? now,
  }) {
    var next = weekend;
    final scoredAt = now ?? DateTime.now();

    if (qualifyingResults != null && qualifyingResults.isNotEmpty) {
      final actual = qualifyingActualOrder(qualifyingResults);
      next = next.copyWith(
        qualiPoints: scoreOrders(predicted: weekend.qualifyingOrder, actualByPosition: actual),
        scoredAt: scoredAt,
      );
    }

    if (raceResults != null && raceResults.isNotEmpty) {
      final actual = raceActualOrder(raceResults);
      next = next.copyWith(
        racePoints: scoreOrders(predicted: weekend.raceOrder, actualByPosition: actual),
        scoredAt: scoredAt,
      );
    }

    return next;
  }
}
