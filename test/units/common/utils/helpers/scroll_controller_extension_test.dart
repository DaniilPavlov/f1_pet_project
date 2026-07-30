// ignore_for_file: cascade_invocations

import 'package:f1_pet_project/common/utils/helpers/scroll_controller_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ScrollControllerX', () {
    testWidgets('animateToBottom no-ops without clients', (tester) async {
      final controller = ScrollController();
      controller.animateToBottom();
      controller.dispose();
    });

    testWidgets('animateToBottom scrolls to max extent', (tester) async {
      final controller = ScrollController();
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            height: 200,
            child: ListView.builder(
              controller: controller,
              itemCount: 40,
              itemBuilder: (_, i) => SizedBox(height: 40, child: Text('$i')),
            ),
          ),
        ),
      );

      expect(controller.offset, 0);
      controller.animateToBottom(duration: const Duration(milliseconds: 1));
      await tester.pumpAndSettle();
      expect(controller.offset, greaterThan(0));
      controller.dispose();
    });
  });
}
