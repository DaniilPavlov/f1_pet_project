import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/common/utils/theme/theme_controller.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/pump_app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CustomAppBar', () {
    testWidgets('shows title and share action', (tester) async {
      var shares = 0;
      final locale = LocaleController();
      final theme = ThemeController();

      await tester.pumpApp(
        MultiProvider(
          providers: [
            Provider<LocaleController>.value(value: locale),
            Provider<ThemeController>.value(value: theme),
          ],
          child: Scaffold(
            appBar: CustomAppBar(
              title: 'Results',
              showPreferences: false,
              onShare: () => shares++,
            ),
            body: const SizedBox.shrink(),
          ),
        ),
        wrapInScaffold: false,
      );

      expect(find.text('Results'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.ios_share));
      await tester.pump();
      expect(shares, 1);
    });

    testWidgets('cycles theme preference', (tester) async {
      final locale = LocaleController();
      final theme = ThemeController();
      await theme.load();

      await tester.pumpApp(
        MultiProvider(
          providers: [
            Provider<LocaleController>.value(value: locale),
            Provider<ThemeController>.value(value: theme),
          ],
          child: Scaffold(
            appBar: const CustomAppBar(title: 'Home', showPreferences: true),
            body: const SizedBox.shrink(),
          ),
        ),
        wrapInScaffold: false,
      );

      expect(find.text('RU'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.brightness_auto));
      await tester.pump();
      expect(theme.preference, AppThemePreference.light);
    });

    testWidgets('shows back when onPop is set', (tester) async {
      var pops = 0;
      final locale = LocaleController();
      final theme = ThemeController();

      await tester.pumpApp(
        MultiProvider(
          providers: [
            Provider<LocaleController>.value(value: locale),
            Provider<ThemeController>.value(value: theme),
          ],
          child: Scaffold(
            appBar: CustomAppBar(
              title: 'News',
              showPreferences: false,
              onPop: () => pops++,
            ),
            body: const SizedBox.shrink(),
          ),
        ),
        wrapInScaffold: false,
      );

      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pump();
      expect(pops, 1);
    });

    testWidgets('hides back on root without onPop', (tester) async {
      final locale = LocaleController();
      final theme = ThemeController();

      await tester.pumpApp(
        MultiProvider(
          providers: [
            Provider<LocaleController>.value(value: locale),
            Provider<ThemeController>.value(value: theme),
          ],
          child: const Scaffold(
            appBar: CustomAppBar(title: 'Home', showPreferences: false),
            body: SizedBox.shrink(),
          ),
        ),
        wrapInScaffold: false,
      );

      expect(find.byIcon(Icons.arrow_back_ios_new), findsNothing);
    });
  });
}
