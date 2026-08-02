/// Предсказание на один уикенд (quali + race) + кэш фактических порядков.
class PredictorWeekendPrediction {
  const PredictorWeekendPrediction({
    required this.round,
    required this.raceName,
    required this.qualifyingOrder,
    required this.raceOrder,
    this.lockedAt,
    this.qualiPoints,
    this.racePoints,
    this.scoredAt,
    this.actualQualifyingOrder,
    this.actualRaceOrder,
  });

  factory PredictorWeekendPrediction.fromJson(Map<String, dynamic> json) {
    return PredictorWeekendPrediction(
      round: json['round'] as String,
      raceName: json['raceName'] as String? ?? '',
      qualifyingOrder: (json['qualifyingOrder'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      raceOrder: (json['raceOrder'] as List<dynamic>? ?? const []).map((e) => e as String).toList(),
      lockedAt: DateTime.tryParse(json['lockedAt'] as String? ?? ''),
      qualiPoints: json['qualiPoints'] as int?,
      racePoints: json['racePoints'] as int?,
      scoredAt: DateTime.tryParse(json['scoredAt'] as String? ?? ''),
      actualQualifyingOrder: (json['actualQualifyingOrder'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      actualRaceOrder: (json['actualRaceOrder'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  final String round;
  final String raceName;
  final List<String> qualifyingOrder;
  final List<String> raceOrder;
  final DateTime? lockedAt;
  final int? qualiPoints;
  final int? racePoints;
  final DateTime? scoredAt;

  /// Закэшированный факт квалификации (чтобы не парсить Jolpica повторно).
  final List<String>? actualQualifyingOrder;

  /// Закэшированный факт гонки.
  final List<String>? actualRaceOrder;

  int get totalPoints => (qualiPoints ?? 0) + (racePoints ?? 0);

  bool get hasAnyPoints => qualiPoints != null || racePoints != null;

  PredictorWeekendPrediction copyWith({
    String? round,
    String? raceName,
    List<String>? qualifyingOrder,
    List<String>? raceOrder,
    DateTime? lockedAt,
    int? qualiPoints,
    int? racePoints,
    DateTime? scoredAt,
    List<String>? actualQualifyingOrder,
    List<String>? actualRaceOrder,
    bool clearLockedAt = false,
  }) {
    return PredictorWeekendPrediction(
      round: round ?? this.round,
      raceName: raceName ?? this.raceName,
      qualifyingOrder: qualifyingOrder ?? this.qualifyingOrder,
      raceOrder: raceOrder ?? this.raceOrder,
      lockedAt: clearLockedAt ? null : (lockedAt ?? this.lockedAt),
      qualiPoints: qualiPoints ?? this.qualiPoints,
      racePoints: racePoints ?? this.racePoints,
      scoredAt: scoredAt ?? this.scoredAt,
      actualQualifyingOrder: actualQualifyingOrder ?? this.actualQualifyingOrder,
      actualRaceOrder: actualRaceOrder ?? this.actualRaceOrder,
    );
  }

  Map<String, dynamic> toJson() => {
    'round': round,
    'raceName': raceName,
    'qualifyingOrder': qualifyingOrder,
    'raceOrder': raceOrder,
    if (lockedAt != null) 'lockedAt': lockedAt!.toIso8601String(),
    if (qualiPoints != null) 'qualiPoints': qualiPoints,
    if (racePoints != null) 'racePoints': racePoints,
    if (scoredAt != null) 'scoredAt': scoredAt!.toIso8601String(),
    if (actualQualifyingOrder != null) 'actualQualifyingOrder': actualQualifyingOrder,
    if (actualRaceOrder != null) 'actualRaceOrder': actualRaceOrder,
  };
}
