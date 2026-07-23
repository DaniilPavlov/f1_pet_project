/// Локальные схемы трасс: `assets/circuits/{circuitId}.png`.
abstract class CircuitLayoutAssets {
  static const _knownIds = <String>{
    'albert_park',
    'americas',
    'bahrain',
    'baku',
    'catalunya',
    'hungaroring',
    'imola',
    'interlagos',
    'jeddah',
    'losail',
    'marina_bay',
    'miami',
    'monaco',
    'monza',
    'red_bull_ring',
    'rodriguez',
    'shanghai',
    'silverstone',
    'spa',
    'suzuka',
    'vegas',
    'villeneuve',
    'yas_marina',
    'zandvoort',
  };

  /// Путь к PNG-схеме трассы или `null`, если ассета нет.
  static String? assetPath(String circuitId) {
    final id = circuitId.trim().toLowerCase();
    if (!_knownIds.contains(id)) {
      return null;
    }
    return 'assets/circuits/$id.png';
  }

  /// Есть ли локальная схема для [circuitId].
  static bool hasLayout(String circuitId) => assetPath(circuitId) != null;
}
