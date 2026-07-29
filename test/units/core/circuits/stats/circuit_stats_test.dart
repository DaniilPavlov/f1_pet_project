import 'package:f1_pet_project/core/circuits/stats/models/circuit_stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CircuitStats', () {
    test('fromJson and labels', () {
      final stats = CircuitStats.fromJson({
        'lengthKm': 5.0,
        'laps': 58,
        'turns': 19,
        'topSpeedKmh': 340.5,
        'elevationM': 12,
      });

      expect(stats.lengthLabel, '5 KM');
      expect(stats.lapsLabel, '58');
      expect(stats.turnsLabel, '19');
      expect(stats.topSpeedLabel, '340.5');
      expect(stats.elevationLabel, '12');
    });
  });
}
