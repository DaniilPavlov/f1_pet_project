import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('ErrorBody', () {
    testWidgets('shows title, subtitle and refresh action', (tester) async {
      var taps = 0;

      await tester.pumpApp(
        ErrorBody(
          onTap: () => taps++,
          title: 'Load failed',
          subtitle: 'Please try again',
        ),
      );

      expect(find.text('Load failed'), findsOneWidget);
      expect(find.text('Please try again'), findsOneWidget);
      expect(find.text('Refresh'), findsOneWidget);

      await tester.tap(find.text('Refresh'));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('falls back to localized no-connection copy', (tester) async {
      await tester.pumpApp(
        ErrorBody(onTap: () {}, title: null, subtitle: null),
      );

      expect(find.text('No connection'), findsOneWidget);
      expect(
        find.text('Once the connection is restored, you will be able to use the app again'),
        findsOneWidget,
      );
    });

    testWidgets('golden', (tester) async {
      await tester.pumpApp(
        const ColoredBox(
          color: Colors.white,
          child: ErrorBody(
            onTap: _noop,
            title: 'Load failed',
            subtitle: 'Please try again',
          ),
        ),
        surfaceSize: const Size(390, 700),
      );
      await tester.pumpForGolden();

      await expectLater(find.byType(ErrorBody), matchesGoldenFile('../goldens/error_body.png'));
    });
  });
}

void _noop() {}
