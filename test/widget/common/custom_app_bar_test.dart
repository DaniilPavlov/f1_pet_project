import 'package:f1_pet_project/common/utils/theme/theme_controller.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/pump_app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CustomAppBar', () {
    testWidgets('shows title and share action', (tester) async {
      var shares = 0;

      await tester.pumpApp(
        Scaffold(
          appBar: CustomAppBar(title: 'Results', showPreferences: false, onShare: () => shares++),
          body: const SizedBox.shrink(),
        ),
        wrapInScaffold: false,
        wrapApp: (app) => ProviderScope(child: app),
      );

      expect(find.text('Results'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.ios_share));
      await tester.pump();
      expect(shares, 1);
    });

    testWidgets('cycles theme preference', (tester) async {
      late ProviderContainer container;

      await tester.pumpApp(
        const Scaffold(
          appBar: CustomAppBar(title: 'Home', showPreferences: true),
          body: SizedBox.shrink(),
        ),
        wrapInScaffold: false,
        wrapApp: (app) {
          container = ProviderContainer();
          addTearDown(container.dispose);
          return UncontrolledProviderScope(container: container, child: app);
        },
      );

      await container.read(themeControllerProvider.notifier).load();
      await tester.pump();

      expect(find.text('RU'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.brightness_auto));
      await tester.pump();
      expect(container.read(themeControllerProvider).preference, AppThemePreference.light);
    });

    testWidgets('shows back when onPop is set', (tester) async {
      var pops = 0;

      await tester.pumpApp(
        Scaffold(
          appBar: CustomAppBar(title: 'News', showPreferences: false, onPop: () => pops++),
          body: const SizedBox.shrink(),
        ),
        wrapInScaffold: false,
        wrapApp: (app) => ProviderScope(child: app),
      );

      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pump();
      expect(pops, 1);
    });

    testWidgets('hides back on root without onPop', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          appBar: CustomAppBar(title: 'Home', showPreferences: false),
          body: SizedBox.shrink(),
        ),
        wrapInScaffold: false,
        wrapApp: (app) => ProviderScope(child: app),
      );

      expect(find.byIcon(Icons.arrow_back_ios_new), findsNothing);
    });
  });
}
