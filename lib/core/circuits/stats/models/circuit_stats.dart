/// Технические характеристики трассы (curated, не Jolpica).
class CircuitStats {
  const CircuitStats({
    required this.lengthKm,
    required this.laps,
    required this.turns,
    required this.topSpeedKmh,
    required this.elevationM,
  });

  factory CircuitStats.fromJson(Map<String, dynamic> json) {
    return CircuitStats(
      lengthKm: (json['lengthKm'] as num).toDouble(),
      laps: (json['laps'] as num).toInt(),
      turns: (json['turns'] as num).toInt(),
      topSpeedKmh: (json['topSpeedKmh'] as num).toDouble(),
      elevationM: (json['elevationM'] as num).toDouble(),
    );
  }

  final double lengthKm;
  final int laps;
  final int turns;
  final double topSpeedKmh;
  final double elevationM;

  String get lengthLabel => '${_trim(lengthKm)} KM';
  String get lapsLabel => '$laps';
  String get turnsLabel => '$turns';
  String get topSpeedLabel => _trim(topSpeedKmh);
  String get elevationLabel => _trim(elevationM);

  static String _trim(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}
