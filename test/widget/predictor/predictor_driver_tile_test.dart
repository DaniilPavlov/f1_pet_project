import 'package:f1_pet_project/core/predictor/components/predictor_driver_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/widget_fixtures.dart';

void main() {
  group('PredictorDriverTile', () {
    testWidgets('renders name and team color fill', (tester) async {
      await tester.pumpApp(
        PredictorDriverTile(
          index: 0,
          driver: WidgetFixtures.verstappen,
          enabled: true,
          constructor: WidgetFixtures.redBull,
        ),
      );

      expect(find.textContaining('Verstappen'), findsOneWidget);
      expect(find.text('Red Bull'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('golden', (tester) async {
      await tester.pumpApp(
        ColoredBox(
          color: Colors.white,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PredictorDriverTile(
                  index: 0,
                  driver: WidgetFixtures.verstappen,
                  enabled: true,
                  constructor: WidgetFixtures.redBull,
                ),
                PredictorDriverTile(
                  index: 1,
                  driver: WidgetFixtures.norris,
                  enabled: true,
                  constructor: WidgetFixtures.ferrari,
                ),
                PredictorDriverTile(
                  index: 2,
                  driver: WidgetFixtures.norris,
                  enabled: false,
                  constructor: WidgetFixtures.ferrari,
                ),
              ],
            ),
          ),
        ),
        surfaceSize: const Size(390, 240),
      );
      await tester.pumpForGolden();

      await expectLater(
        find.byType(Column).first,
        matchesGoldenFile('../goldens/predictor_driver_tiles.png'),
      );
    });
  });
}
