import 'package:f1_pet_project/common/widgets/bottom_sheets/bottom_sheet_permissions.dart';
import 'package:f1_pet_project/common/widgets/career/espn_driver_news_section.dart';
import 'package:f1_pet_project/common/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/common/widgets/text_fields/race_picker_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/text_fields/race_picker_field.dart';
import 'package:f1_pet_project/common/widgets/text_fields/season_picker_bottom_sheet.dart';
import 'package:f1_pet_project/core/circuits/components/circuits_list.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_location_model.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/results/race_search/components/search_fields_section.dart';
import 'package:f1_pet_project/core/results/race_search/components/search_result_section.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/fake_repositories.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/widget_fixtures.dart';

void main() {
  group('CircuitsList', () {
    testWidgets('renders circuits with and without layout asset', (tester) async {
      await tester.pumpApp(
        CircuitsList(
          circuits: [
            ControllerFixtures.circuit,
            CircuitModel(
              circuitId: 'unknown_track',
              url: 'http://example.com',
              circuitName: 'Unknown GP',
              location: CircuitLocationModel(
                lat: '0',
                long: '0',
                locality: 'Somewhere',
                country: 'Nowhere',
              ),
            ),
          ],
        ),
      );

      expect(find.text('Monaco'), findsOneWidget);
      expect(find.text('Unknown GP'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_right_alt), findsOneWidget);
    });
  });

  group('RedBorderContainer', () {
    testWidgets('shows arrow when tappable', (tester) async {
      var taps = 0;
      await tester.pumpApp(
        RedBorderContainer(title: 'Drivers', onTap: () => taps++),
      );

      expect(find.byIcon(Icons.arrow_right_alt), findsOneWidget);
      await tester.tap(find.text('Drivers'));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('hides arrow when not tappable', (tester) async {
      await tester.pumpApp(const RedBorderContainer(title: 'Static'));
      expect(find.byIcon(Icons.arrow_right_alt), findsNothing);
    });
  });

  group('BottomSheetPermissions', () {
    testWidgets('shows text and settings action', (tester) async {
      var settings = 0;

      await tester.pumpApp(
        SizedBox(
          height: 280,
          child: BottomSheetPermissions(
            text: 'Allow notifications',
            onTapSettings: () => settings++,
          ),
        ),
      );

      expect(find.text('Allow notifications'), findsOneWidget);
      await tester.tap(find.text(AppLocalizationsEn().settings));
      await tester.pump();
      expect(settings, 1);
    });
  });

  group('EspnDriverNewsSection', () {
    testWidgets('hides when empty', (tester) async {
      await tester.pumpApp(const EspnDriverNewsSection(news: []));
      expect(find.byType(EspnDriverNewsSection), findsOneWidget);
    });

    testWidgets('renders articles', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: EspnDriverNewsSection(
            title: 'Related',
            news: const [
              NewsArticleModel(id: 1, headline: 'Max news', description: 'd', webUrl: 'https://x.com'),
            ],
          ),
        ),
      );

      expect(find.text('Related'), findsOneWidget);
      expect(find.text('Max news'), findsOneWidget);
    });
  });

  group('RacePickerBottomSheet', () {
    testWidgets('lists races and pops selection', (tester) async {
      RacePick? picked;

      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              picked = await showModalBottomSheet<RacePick>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => Provider<RaceWeekendRepository>.value(
                  value: FakeRaceWeekendRepository(
                    seasonRaces: ControllerFixtures.scheduleModel.raceTable.races,
                  ),
                  child: const RacePickerBottomSheet(seasonYear: '2024', selectedRound: '5'),
                ),
              );
            },
            child: const Text('open'),
          ),
        ),
        surfaceSize: const Size(400, 2000),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Monaco Grand Prix'), findsOneWidget);
      await tester.tap(find.textContaining('Monaco Grand Prix'));
      await tester.pumpAndSettle();

      expect(picked?.round, '5');
      expect(picked?.title, contains('Monaco'));
    });

    testWidgets('shows error state', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => Provider<RaceWeekendRepository>.value(
                value: FakeRaceWeekendRepository(seasonRaces: const [], throwOnSeasonRaces: true),
                child: const RacePickerBottomSheet(seasonYear: '2024', selectedRound: null),
              ),
            ),
            child: const Text('open'),
          ),
        ),
        surfaceSize: const Size(400, 2000),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text(AppLocalizationsEn().racesLoadError), findsOneWidget);
    });
  });

  group('SeasonPickerBottomSheet', () {
    testWidgets('lists years and pops selection', (tester) async {
      String? selected;

      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              selected = await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => SeasonPickerBottomSheet(
                  seasonsRepository: FakeSeasonsRepository(years: ['2025', '2024']),
                  selectedYear: '2024',
                ),
              );
            },
            child: const Text('open'),
          ),
        ),
        surfaceSize: const Size(400, 2000),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2025'));
      await tester.pumpAndSettle();
      expect(selected, '2025');
    });
  });

  group('RacePickerField', () {
    testWidgets('enabled field shows select-race hint', (tester) async {
      final display = TextEditingController();
      addTearDown(display.dispose);

      await tester.pumpApp(
        RacePickerField(
          displayController: display,
          seasonYear: '2024',
          onPicked: (_) {},
        ),
      );

      expect(find.text(AppLocalizationsEn().selectRace), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
    });
  });

  group('SearchFieldsSection / SearchResultSection', () {
    testWidgets('renders fields and error message', (tester) async {
      final controller = RaceSearchScreenController(
        l10n: AppLocalizationsEn(),
        fetchRaceResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
      );
      addTearDown(controller.dispose);
      controller.yearController.text = '2024';
      controller.selectedSeason = '2024';
      controller.roundController.text = '1';
      await controller.loadRaceResults();

      await tester.pumpApp(
        Provider.value(
          value: controller,
          child: const SingleChildScrollView(
            child: Column(
              children: [
                SearchFieldsSection(),
                SearchResultSection(),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(SearchFieldsSection), findsOneWidget);
      expect(find.text(AppLocalizationsEn().raceNotFound), findsOneWidget);
    });

    testWidgets('shows race name when results loaded', (tester) async {
      final base = WidgetFixtures.race;
      final race = RacesModel(
        season: base.season,
        round: base.round,
        url: base.url,
        raceName: base.raceName,
        circuit: base.circuit,
        date: base.date,
        time: base.time,
        firstPractice: null,
        secondPractice: null,
        thirdPractice: null,
        qualifying: null,
        sprint: null,
        results: [
          ...?base.results,
          WidgetFixtures.raceResultSecond,
        ],
        qualifyingResults: null,
        pitStops: null,
      );

      final controller = RaceSearchScreenController(
        l10n: AppLocalizationsEn(),
        fetchRaceResultsForTest: ({required year, required round}) async => ScheduleModel(
          raceTable: RaceTableModel(season: '2024', round: '5', races: [race]),
        ),
      );
      addTearDown(controller.dispose);
      controller.yearController.text = '2024';
      controller.roundController.text = '5';
      await controller.loadRaceResults();
      // Clear animateToBottom delay scheduled by loadRaceResults.
      await tester.pump(const Duration(milliseconds: 150));

      await tester.pumpApp(
        Provider.value(
          value: controller,
          child: const SingleChildScrollView(child: SearchResultSection()),
        ),
        surfaceSize: const Size(800, 1200),
        locale: const Locale('ru'),
      );

      expect(find.text('Monaco Grand Prix'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 150));
    });
  });

  group('CustomTextField cupertino', () {
    testWidgets('builds CupertinoTextField on iOS', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpApp(
        CustomTextField(controller: controller, label: 'Code', hintText: 'VER'),
      );

      expect(find.byType(CupertinoTextField), findsOneWidget);
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
