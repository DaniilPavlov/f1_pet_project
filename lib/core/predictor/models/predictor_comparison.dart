import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';

/// Одна строка сравнения предикта с фактом.
class PredictorComparisonRow {
  const PredictorComparisonRow({
    required this.position,
    required this.predictedDriverId,
    required this.actualDriverId,
    required this.isCorrect,
  });

  final int position;
  final String? predictedDriverId;
  final String? actualDriverId;
  final bool isCorrect;
}

/// Результат сравнения сессии (quali или race).
class PredictorSessionCompare {
  const PredictorSessionCompare({
    required this.rows,
    required this.points,
  });

  final List<PredictorComparisonRow> rows;
  final int points;

  static PredictorSessionCompare fromOrders({
    required List<String> predicted,
    required List<String> actual,
  }) {
    final length = predicted.length > actual.length ? predicted.length : actual.length;
    final rows = <PredictorComparisonRow>[];
    var points = 0;
    for (var i = 0; i < length; i++) {
      final predictedId = i < predicted.length ? predicted[i] : null;
      final actualId = i < actual.length ? actual[i] : null;
      final correct = predictedId != null && actualId != null && predictedId == actualId;
      if (correct) {
        points++;
      }
      rows.add(
        PredictorComparisonRow(
          position: i + 1,
          predictedDriverId: predictedId,
          actualDriverId: actualId,
          isCorrect: correct,
        ),
      );
    }
    return PredictorSessionCompare(rows: rows, points: points);
  }
}

/// Подпись пилота для UI сравнения.
String predictorDriverLabel(DriverModel? driver, String? fallbackId) {
  if (driver != null) {
    final code = driver.code;
    if (code != null && code.isNotEmpty && code.toLowerCase() != 'none') {
      return '$code · ${driver.familyName}';
    }
    return '${driver.givenName} ${driver.familyName}'.trim();
  }
  return fallbackId ?? '—';
}
