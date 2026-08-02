/// Локальное предсказание на один уикенд (quali + race).
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
  };
}
