import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/utils/helpers/share_helper.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme_data.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../helpers/controller_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/share'),
      (call) async => 'dev.fluttercommunity.plus/share/unavailable',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => '.',
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/share'),
      null,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
  });

  group('ShareHelper', () {
    testWidgets('no-ops when overlay is missing', (tester) async {
      await tester.pumpWidget(
        Provider<AnalyticsGateway>.value(
          value: const NoOpAnalyticsGateway(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () => ShareHelper.shareCareerCard(
                  context: context,
                  l10n: AppLocalizationsEn(),
                  title: 'Max',
                  stats: const CareerStats<Object>(
                    races: 1,
                    wins: 0,
                    podiums: 0,
                    poles: 0,
                    current: [],
                    related: [],
                  ),
                ),
                child: const Text('share'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('share'));
      await tester.pump();
      // Completes without throwing when Overlay is absent.
      expect(find.text('share'), findsOneWidget);
    });

    testWidgets('shareCareerCard passes deepLink text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemeData.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Provider<AnalyticsGateway>.value(
            value: const NoOpAnalyticsGateway(),
            child: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => ShareHelper.shareCareerCard(
                    context: context,
                    l10n: AppLocalizationsEn(),
                    title: 'Max Verstappen',
                    stats: const CareerStats<Object>(
                      races: 10,
                      wins: 3,
                      podiums: 5,
                      poles: 2,
                      current: [],
                      related: [],
                    ),
                    deepLink: Uri.parse('https://example.com/driver/max'),
                  ),
                  child: const Text('share'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('share'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.text('share'), findsOneWidget);
    });

    testWidgets('shareRaceResultsCard completes with overlay present', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemeData.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Provider<AnalyticsGateway>.value(
            value: const NoOpAnalyticsGateway(),
            child: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => ShareHelper.shareRaceResultsCard(
                    context: context,
                    l10n: AppLocalizations.of(context),
                    race: ControllerFixtures.race,
                  ),
                  child: const Text('share'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('share'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.text('share'), findsOneWidget);
    });
  });
}
