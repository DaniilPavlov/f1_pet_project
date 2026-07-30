import 'package:f1_pet_project/common/widgets/circuits/circuit_stats_grid.dart';
import 'package:f1_pet_project/core/circuits/stats/models/circuit_stats.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('CircuitStatsGrid', () {
    testWidgets('renders all stat values', (tester) async {
      await tester.pumpApp(
        const CircuitStatsGrid(
          stats: CircuitStats(
            lengthKm: 5.412,
            laps: 53,
            turns: 15,
            topSpeedKmh: 340,
            elevationM: 40.5,
          ),
        ),
      );

      expect(find.text('5.412 KM'), findsOneWidget);
      expect(find.text('53'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
      expect(find.text('340'), findsOneWidget);
      expect(find.text('40.5'), findsOneWidget);
    });
  });
}
