import 'package:f1_pet_project/common/utils/theme/app_theme_data.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BlackButton with leadIcon and shadow', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeData.light(),
        home: Scaffold(
          body: BlackButton(
            onTap: () => taps++,
            text: 'Go',
            isDisabled: false,
            haveShadow: true,
            leadIcon: const Icon(Icons.flag),
          ),
        ),
      ),
    );

    expect(find.text('Go'), findsOneWidget);
    expect(find.byIcon(Icons.flag), findsOneWidget);
    await tester.tap(find.text('Go'));
    expect(taps, 1);
  });

  testWidgets('BlackButton with midIcon only', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeData.light(),
        home: Scaffold(
          body: BlackButton(
            onTap: () {},
            text: 'ignored',
            isDisabled: false,
            midIcon: const Icon(Icons.star),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('BlackButton disabled swallows taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeData.light(),
        home: Scaffold(
          body: BlackButton(
            onTap: () => taps++,
            text: 'Go',
            isDisabled: true,
            haveShadow: true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    expect(taps, 0);
  });
}
