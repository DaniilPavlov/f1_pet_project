import 'package:f1_pet_project/common/widgets/circuits/circuit_layout_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('CircuitLayoutImage', () {
    testWidgets('renders nothing for unknown circuit', (tester) async {
      await tester.pumpApp(const CircuitLayoutImage(circuitId: 'unknown_track'));
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('builds image for known circuit', (tester) async {
      await tester.pumpApp(const CircuitLayoutImage(circuitId: 'monaco'));
      expect(find.byType(CircuitLayoutImage), findsOneWidget);
    });
  });
}
