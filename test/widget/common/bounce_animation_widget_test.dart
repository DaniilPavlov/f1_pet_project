import 'package:f1_pet_project/common/widgets/nav_bar/bounce_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('BounceAnimationWidget', () {
    testWidgets('invokes onPressed and animates selection', (tester) async {
      var taps = 0;

      await tester.pumpApp(
        BounceAnimationWidget(
          isSelected: false,
          onPressed: () => taps++,
          child: const Text('Tab'),
        ),
      );

      await tester.tap(find.text('Tab'));
      await tester.pump();
      expect(taps, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BounceAnimationWidget(
              isSelected: true,
              onPressed: () => taps++,
              child: const Text('Tab'),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Tab'), findsOneWidget);
    });
  });
}
