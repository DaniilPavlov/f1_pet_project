/// Контракт custom-scheme ссылок `f1pet://…`.
abstract class F1PetDeepLinks {
  static const scheme = 'f1pet';

  static Uri driver(String driverId) => Uri(scheme: scheme, host: 'driver', pathSegments: [driverId]);

  static Uri constructor(String constructorId) =>
      Uri(scheme: scheme, host: 'constructor', pathSegments: [constructorId]);

  static Uri circuit(String circuitId) => Uri(scheme: scheme, host: 'circuit', pathSegments: [circuitId]);

  static Uri raceLive() => Uri(scheme: scheme, host: 'race', pathSegments: const ['live']);

  /// Конкретный уикенд: `f1pet://race/<season>/<round>` (тап по reminder).
  static Uri race(String season, String round) =>
      Uri(scheme: scheme, host: 'race', pathSegments: [season, round]);
}
