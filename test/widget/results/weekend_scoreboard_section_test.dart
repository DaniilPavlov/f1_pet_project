import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/results/components/weekend_scoreboard_section.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('WeekendScoreboardSection', () {
    testWidgets('shows shimmer while loading', (tester) async {
      await tester.pumpApp(const WeekendScoreboardSection(scoreboard: AsyncValue.loading(), locale: Locale('en')));

      expect(find.byType(WeekendScoreboardSection), findsOneWidget);
    });

    testWidgets('renders event card with sessions', (tester) async {
      final event = EspnScoreboardEvent(
        name: 'Monaco Grand Prix',
        shortName: 'MON',
        statusState: 'in',
        statusDetail: 'Live',
        circuitName: 'Circuit de Monaco',
        circuitCity: 'Monte Carlo',
        circuitCountry: 'Monaco',
        sessions: [
          EspnScoreboardSession(
            abbreviation: 'Race',
            statusState: 'in',
            statusDetail: 'Live',
            date: DateTime(2024, 5, 26, 13),
            leaderName: 'Max Verstappen',
            isWinner: false,
          ),
          const EspnScoreboardSession(abbreviation: 'Q', statusState: 'post', statusDetail: 'Final'),
        ],
      );

      await tester.pumpApp(
        SingleChildScrollView(
          child: WeekendScoreboardSection(
            scoreboard: AsyncValue.value(value: event),
            locale: const Locale('en'),
          ),
        ),
      );

      expect(find.text('MON'), findsOneWidget);
      expect(find.text('Circuit de Monaco'), findsOneWidget);
      expect(find.text('Race'), findsWidgets);
      expect(find.textContaining('Verstappen'), findsOneWidget);
    });

    testWidgets('renders nothing when value is null and not loading', (tester) async {
      await tester.pumpApp(const WeekendScoreboardSection(scoreboard: AsyncValue.value(), locale: Locale('en')));

      expect(find.text('MON'), findsNothing);
    });

    testWidgets('shows share action for loaded event', (tester) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('dev.fluttercommunity.plus/share'),
        (call) async => 'dev.fluttercommunity.plus/share/unavailable',
      );
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/share'),
          null,
        );
      });

      final event = EspnScoreboardEvent(
        name: 'Monaco Grand Prix',
        shortName: 'MON',
        statusState: 'post',
        statusDetail: 'Final',
        sessions: const [
          EspnScoreboardSession(abbreviation: 'Race', statusState: 'post', statusDetail: 'Final'),
        ],
      );

      await tester.pumpApp(
        SingleChildScrollView(
          child: WeekendScoreboardSection(
            scoreboard: AsyncValue.value(value: event),
            locale: const Locale('en'),
          ),
        ),
        wrapApp: (app) => Provider<AnalyticsGateway>.value(
          value: const NoOpAnalyticsGateway(),
          child: app,
        ),
      );

      expect(find.byTooltip(AppLocalizationsEn().shareWeekendSummary), findsOneWidget);
      await tester.tap(find.byIcon(Icons.ios_share));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.ios_share), findsOneWidget);
    });
  });
}
