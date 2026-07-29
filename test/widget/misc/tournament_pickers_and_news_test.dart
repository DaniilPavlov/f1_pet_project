import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/widgets/shimmer/schedule_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/constructor_picker_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/text_fields/driver_picker_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/text_fields/race_picker_field.dart';
import 'package:f1_pet_project/common/widgets/text_fields/season_picker_field.dart';
import 'package:f1_pet_project/core/circuits/map/components/map_controls_widget.dart';
import 'package:f1_pet_project/core/news/components/news_article_tile.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/results/race_search/components/info_message_section.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/fake_repositories.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/recording_analytics_gateway.dart';

void main() {
  group('InfoMessageSection', () {
    testWidgets('renders race search info', (tester) async {
      await tester.pumpApp(const InfoMessageSection());
      expect(find.text(AppLocalizationsEn().raceSearchInfo), findsOneWidget);
    });
  });

  group('ScheduleShimmer', () {
    testWidgets('builds shimmer skeletons', (tester) async {
      await tester.pumpApp(const ScheduleShimmer());
      expect(find.byType(ScreenShimmer), findsOneWidget);
      expect(find.byType(ScheduleShimmer), findsOneWidget);
    });
  });

  group('MapControlsWidget', () {
    testWidgets('invokes zoom and location callbacks', (tester) async {
      var plus = 0;
      var minus = 0;
      var location = 0;

      await tester.pumpApp(
        MapControlsWidget(
          onPlusPressed: () => plus++,
          onMinusPressed: () => minus++,
          onUserLocationPressed: () => location++,
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.tap(find.byIcon(Icons.remove));
      await tester.tap(find.byIcon(Icons.navigation));
      await tester.pump();

      expect(plus, 1);
      expect(minus, 1);
      expect(location, 1);
    });
  });

  group('DriverPickerBottomSheet gaps', () {
    testWidgets('shows empty load error', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => DriverPickerBottomSheet(loadDrivers: () async => const []),
            ),
            child: const Text('open'),
          ),
        ),
        surfaceSize: const Size(400, 2000),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text(AppLocalizationsEn().driversLoadError), findsOneWidget);
    });

    testWidgets('shows empty search results', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => DriverPickerBottomSheet(
                loadDrivers: () async => [ControllerFixtures.driver],
                enableSearch: true,
              ),
            ),
            child: const Text('open'),
          ),
        ),
        surfaceSize: const Size(400, 2000),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'zzzz');
      await tester.pumpAndSettle();
      expect(find.text(AppLocalizationsEn().h2hDriversEmpty), findsOneWidget);
    });
  });

  group('ConstructorPickerBottomSheet gaps', () {
    testWidgets('shows empty load error and empty search', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => ConstructorPickerBottomSheet(
                loadConstructors: () async => const [],
              ),
            ),
            child: const Text('open'),
          ),
        ),
        surfaceSize: const Size(400, 2000),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text(AppLocalizationsEn().constructorsLoadError), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();

      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => ConstructorPickerBottomSheet(
                loadConstructors: () async => [ControllerFixtures.constructor],
                enableSearch: true,
              ),
            ),
            child: const Text('open'),
          ),
        ),
        surfaceSize: const Size(400, 2000),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'zzzz');
      await tester.pumpAndSettle();
      expect(find.text(AppLocalizationsEn().h2hConstructorsEmpty), findsOneWidget);
    });
  });

  group('SeasonPickerField open', () {
    testWidgets('updates controller from sheet', (tester) async {
      final controller = TextEditingController(text: '2024');
      addTearDown(controller.dispose);
      var changed = 0;

      await tester.pumpApp(
        SeasonPickerField(
          controller: controller,
          onChanged: () => changed++,
        ),
        surfaceSize: const Size(400, 2000),
        wrapApp: (app) => Provider<SeasonsRepository>.value(
          value: FakeSeasonsRepository(years: ['2025', '2024']),
          child: app,
        ),
      );

      await tester.tap(find.byType(SeasonPickerField));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2025'));
      await tester.pumpAndSettle();

      expect(controller.text, '2025');
      expect(changed, 1);
    });
  });

  group('RacePickerField open', () {
    testWidgets('updates display from sheet', (tester) async {
      final display = TextEditingController();
      addTearDown(display.dispose);
      RacePick? picked;

      await tester.pumpApp(
        RacePickerField(
          displayController: display,
          seasonYear: '2024',
          onPicked: (p) => picked = p,
        ),
        surfaceSize: const Size(400, 2000),
        wrapApp: (app) => Provider<RaceWeekendRepository>.value(
          value: FakeRaceWeekendRepository(
            seasonRaces: ControllerFixtures.scheduleModel.raceTable.races,
          ),
          child: app,
        ),
      );

      await tester.tap(find.byType(RacePickerField));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, '5. Monaco Grand Prix'));
      await tester.pumpAndSettle();

      expect(picked?.round, '5');
      expect(display.text, contains('Monaco'));
    });
  });

  group('NewsArticleTile', () {
    testWidgets('logs analytics on tap and renders without meta', (tester) async {
      final gateway = RecordingAnalyticsGateway();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/url_launcher'),
        (call) async {
          if (call.method.contains('canLaunch') || call.method == 'launch') {
            return true;
          }
          return null;
        },
      );
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher'),
          null,
        );
      });

      await tester.pumpApp(
        Provider<AnalyticsGateway>.value(
          value: gateway,
          child: NewsArticleTile(
            article: const NewsArticleModel(
              id: 1,
              headline: 'No meta',
              description: '',
              webUrl: 'https://www.espn.com/f1/story',
              imageUrl: 'https://example.com/img.png',
            ),
            locale: const Locale('en'),
          ),
        ),
      );

      expect(find.text('No meta'), findsOneWidget);
      await tester.tap(find.text('No meta'));
      await tester.pump();
      expect(gateway.events.whereType<NewsOpened>(), hasLength(1));
    });
  });
}
