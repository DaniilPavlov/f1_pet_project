import 'package:f1_pet_project/common/widgets/career/career_info_row.dart';
import 'package:f1_pet_project/common/widgets/containers/rounded_container.dart';
import 'package:f1_pet_project/common/widgets/shimmer/news_list_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/season_picker_field.dart';
import 'package:f1_pet_project/core/results/components/last_race_table_section.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/widget_fixtures.dart';

void main() {
  group('CareerInfoRow', () {
    testWidgets('renders label with text value', (tester) async {
      await tester.pumpApp(const CareerInfoRow(label: 'Wins', value: '54'));

      expect(find.text('Wins'), findsOneWidget);
      expect(find.text('54'), findsOneWidget);
    });

    testWidgets('renders valueLeading and valueWidget', (tester) async {
      await tester.pumpApp(
        const CareerInfoRow(
          label: 'Team',
          valueLeading: Icon(Icons.flag, key: Key('leading')),
          valueWidget: Text('Red Bull', key: Key('value')),
        ),
      );

      expect(find.byKey(const Key('leading')), findsOneWidget);
      expect(find.byKey(const Key('value')), findsOneWidget);
    });
  });

  group('RoundedContainer', () {
    testWidgets('wraps child and invokes onTap', (tester) async {
      var taps = 0;

      await tester.pumpApp(RoundedContainer(onTap: () => taps++, child: const Text('Inside')));

      await tester.tap(find.text('Inside'));
      await tester.pump();
      expect(taps, 1);
    });
  });

  group('NewsListShimmer', () {
    testWidgets('builds list shimmer', (tester) async {
      await tester.pumpApp(const NewsListShimmer(itemCount: 2));

      expect(find.byType(ScreenShimmer), findsOneWidget);
      expect(find.byType(NewsListShimmer), findsOneWidget);
    });
  });

  group('LastRaceTableSection', () {
    testWidgets('shows race title season and round', (tester) async {
      final base = WidgetFixtures.race;
      final third = ResultsModel(
        number: '3',
        position: '3',
        positionText: '3',
        points: '15',
        driver: WidgetFixtures.norris,
        constructor: WidgetFixtures.ferrari,
        grid: '3',
        laps: '78',
        status: 'Finished',
        time: null,
        fastestLap: null,
      );
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
        results: [...?base.results, third],
        qualifyingResults: null,
        pitStops: null,
      );

      await tester.pumpApp(
        SingleChildScrollView(child: LastRaceTableSection(lastRace: race)),
        surfaceSize: const Size(800, 1200),
        locale: const Locale('ru'),
      );

      expect(find.text('Monaco Grand Prix'), findsOneWidget);
      expect(find.byType(LastRaceTableSection), findsOneWidget);
    });
  });

  group('SeasonPickerField', () {
    testWidgets('renders read-only season field', (tester) async {
      final controller = TextEditingController(text: '2024');
      addTearDown(controller.dispose);

      await tester.pumpApp(
        SeasonPickerField(controller: controller),
        wrapApp: (app) => ProviderScope(
          overrides: [
            seasonsRepositoryProvider.overrideWithValue(FakeSeasonsRepository(years: ['2025', '2024'])),
          ],
          child: app,
        ),
      );

      expect(find.byType(SeasonPickerField), findsOneWidget);
      expect(find.text('2024'), findsOneWidget);
    });
  });
}
