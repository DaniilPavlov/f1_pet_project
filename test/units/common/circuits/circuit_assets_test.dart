import 'package:f1_pet_project/common/circuits/circuit_layout_assets.dart';
import 'package:f1_pet_project/common/circuits/circuit_stats_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CircuitLayoutAssets', () {
    test('returns asset path for known circuit', () {
      expect(CircuitLayoutAssets.assetPath('hungaroring'), 'assets/circuits/hungaroring.png');
      expect(CircuitLayoutAssets.hasLayout('Zandvoort'), isTrue);
    });

    test('returns null for unknown circuit', () {
      expect(CircuitLayoutAssets.assetPath('unknown_track'), isNull);
      expect(CircuitLayoutAssets.hasLayout('unknown_track'), isFalse);
    });
  });

  group('CircuitStatsRepository', () {
    test('loads hungaroring stats from asset', () async {
      final stats = await CircuitStatsRepository(bundle: rootBundle).of('hungaroring');
      expect(stats, isNotNull);
      expect(stats!.lengthKm, 4.381);
      expect(stats.laps, 70);
      expect(stats.turns, 14);
      expect(stats.topSpeedKmh, 310.3);
      expect(stats.elevationM, 34.62);
    });

    test('returns null for unknown circuit', () async {
      final stats = await CircuitStatsRepository(bundle: rootBundle).of('nope');
      expect(stats, isNull);
    });
  });
}
