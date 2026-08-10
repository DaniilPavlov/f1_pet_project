import 'package:flutter/foundation.dart';

/// Аргументы семейства лидерборда предиктора.
@immutable
class PredictorLeaderboardPageArgs {
  const PredictorLeaderboardPageArgs({required this.year, required this.myPoints});

  final String year;
  final int myPoints;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PredictorLeaderboardPageArgs && year == other.year && myPoints == other.myPoints;

  @override
  int get hashCode => Object.hash(year, myPoints);
}
