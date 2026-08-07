import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/core/news/components/news_article_tile.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/schedule/components/schedule_race_featured_card.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('NewsArticleTile', () {
    testWidgets('renders headline, description and meta', (tester) async {
      final article = NewsArticleModel(
        id: 1,
        headline: 'Hamilton wins',
        description: 'A great race',
        webUrl: 'https://www.espn.com/f1/story',
        byline: 'ESPN Staff',
        published: DateTime(2024, 5, 26),
      );

      await tester.pumpApp(
        NewsArticleTile(article: article, locale: const Locale('en')),
        wrapApp: (app) => ProviderScope(
          overrides: [analyticsGatewayProvider.overrideWithValue(const NoOpAnalyticsGateway())],
          child: app,
        ),
      );

      expect(find.text('Hamilton wins'), findsOneWidget);
      expect(find.text('A great race'), findsOneWidget);
      expect(find.text('ESPN Staff'), findsOneWidget);
    });
  });

  group('ScheduleRaceFeaturedCard', () {
    testWidgets('shows race info, countdown and CTA', (tester) async {
      var taps = 0;
      final cta = AppLocalizationsEn().scheduleViewSessions;

      await tester.pumpApp(
        SingleChildScrollView(
          child: ScheduleRaceFeaturedCard(
            race: ControllerFixtures.race,
            countdown: const CountdownParts(days: 2, hours: 3, minutes: 4, seconds: 5),
            showCountdown: true,
            onViewSchedule: () => taps++,
          ),
        ),
      );

      expect(find.text('Monaco Grand Prix'), findsOneWidget);
      expect(find.text('Monaco'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);

      await tester.ensureVisible(find.text(cta));
      await tester.tap(find.text(cta));
      await tester.pump();
      expect(taps, 1);
    });
  });
}
