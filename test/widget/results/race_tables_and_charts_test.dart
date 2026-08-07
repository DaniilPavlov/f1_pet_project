import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/career/espn_driver_photo.dart';
import 'package:f1_pet_project/common/widgets/career/network_hero_photo.dart';
import 'package:f1_pet_project/common/widgets/tables/tournament_constructors_table.dart';
import 'package:f1_pet_project/core/results/components/race_table_detail_row.dart';
import 'package:f1_pet_project/core/results/components/weekend_scoreboard_section.dart';
import 'package:f1_pet_project/core/results/h2h/components/h2h_filters_card.dart';
import 'package:f1_pet_project/core/results/h2h/components/h2h_points_chart.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_round_score.dart';
import 'package:f1_pet_project/core/results/models/average_speed_model.dart';
import 'package:f1_pet_project/core/results/models/fastest_lap_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/models/time_model.dart';
import 'package:f1_pet_project/core/schedule/components/schedule_race_sessions_sheet.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/widget_fixtures.dart';

void main() {
  group('AppTheme tokens', () {
    test('exposes brand constants', () {
      expect(AppTheme.chrome, isNotNull);
      expect(AppTheme.defaultBorderRadius, isA<BorderRadius>());
      expect(AppTheme.defaultRadius, isA<Radius>());
      expect(AppTheme.pink, isNotNull);
    });
  });

  group('AverageSpeedModel / FastestLapModel', () {
    test('fromJson parses nested speed', () {
      final lap = FastestLapModel.fromJson({
        'rank': '1',
        'lap': '44',
        'Time': {'millis': '80000', 'time': '1:20.000'},
        'AverageSpeed': {'units': 'kph', 'speed': '210.5'},
      });

      expect(lap.rank, '1');
      expect(lap.time.time, '1:20.000');
      expect(lap.averageSpeed?.speed, '210.5');
      expect(AverageSpeedModel.fromJson({'units': 'kph', 'speed': '200'}).units, 'kph');
    });

    test('fromJson throws on invalid payload', () {
      expect(() => AverageSpeedModel.fromJson(const {}), throwsA(isA<Exception>()));
      expect(() => FastestLapModel.fromJson(const {}), throwsA(isA<Exception>()));
    });
  });

  group('raceTableDetailRowChildren', () {
    testWidgets('renders DNF and fastest-lap highlight', (tester) async {
      final classified = ResultsModel(
        number: '1',
        position: '1',
        positionText: '1',
        points: '25',
        driver: ControllerFixtures.driver,
        constructor: ControllerFixtures.constructor,
        grid: '1',
        laps: '78',
        status: 'Finished',
        time: TimeModel(millis: '5400000', time: '1:30:00.000'),
        fastestLap: FastestLapModel(
          rank: '1',
          lap: '40',
          time: TimeModel(millis: '80000', time: '1:20.000'),
          averageSpeed: AverageSpeedModel(units: 'kph', speed: '210'),
        ),
      );
      final dnf = ResultsModel(
        number: '16',
        position: 'R',
        positionText: 'R',
        points: '0',
        driver: WidgetFixtures.norris,
        constructor: WidgetFixtures.ferrari,
        grid: '5',
        laps: '10',
        status: 'Retired',
        time: null,
        fastestLap: FastestLapModel(
          rank: '5',
          lap: '8',
          time: TimeModel(millis: '81000', time: '1:21.000'),
          averageSpeed: null,
        ),
      );

      await tester.pumpApp(
        Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: raceTableDetailRowChildren(
                      classified,
                      '1:20.000',
                      l10n,
                    ).map((w) => Expanded(child: w)).toList(),
                  ),
                  Row(
                    children: raceTableDetailRowChildren(dnf, '1:20.000', l10n).map((w) => Expanded(child: w)).toList(),
                  ),
                ],
              ),
            );
          },
        ),
        surfaceSize: const Size(800, 400),
      );

      expect(find.textContaining('Verstappen'), findsOneWidget);
      expect(find.text('Retired'), findsOneWidget);
      expect(find.textContaining('1:20.000'), findsWidgets);
      expect(find.text('1:21.000'), findsOneWidget);
    });
  });

  group('EspnDriverPhoto', () {
    testWidgets('delegates to NetworkHeroPhoto', (tester) async {
      await tester.pumpApp(const EspnDriverPhoto(photoUrl: null, isLoading: true));
      expect(find.byType(NetworkHeroPhoto), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('H2hPointsChart', () {
    testWidgets('paints empty and non-empty timelines', (tester) async {
      await tester.pumpApp(
        const H2hPointsChart(
          timeline: H2hPointsTimeline(points: []),
          colorA: Colors.red,
          colorB: Colors.blue,
        ),
      );
      expect(find.byType(H2hPointsChart), findsOneWidget);

      final timeline = H2hPointsTimeline.fromScores(
        scoresA: const [
          H2hRoundScore(season: '2024', round: '1', raceName: 'Bahrain', points: 25),
          H2hRoundScore(season: '2024', round: '2', raceName: 'Saudi', points: 18),
        ],
        scoresB: const [
          H2hRoundScore(season: '2024', round: '1', raceName: 'Bahrain', points: 18),
          H2hRoundScore(season: '2024', round: '2', raceName: 'Saudi', points: 25),
        ],
        seasonScope: '2024',
      );

      await tester.pumpApp(
        H2hPointsChart(timeline: timeline, colorA: Colors.red, colorB: Colors.blue),
        surfaceSize: const Size(390, 280),
      );
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('ScheduleRaceSessionsSheet.show', () {
    testWidgets('opens sheet with sprint sessions', (tester) async {
      final base = ControllerFixtures.race;
      final race = RacesModel(
        season: base.season,
        round: base.round,
        url: base.url,
        raceName: base.raceName,
        circuit: base.circuit,
        date: base.date,
        time: base.time,
        firstPractice: RaceDateModel(date: '2024-05-24', time: '12:00:00Z'),
        secondPractice: RaceDateModel(date: '2024-05-24', time: '16:00:00Z'),
        thirdPractice: null,
        qualifying: RaceDateModel(date: '2024-05-25', time: '14:00:00Z'),
        sprintQualifying: RaceDateModel(date: '2024-05-25', time: '12:00:00Z'),
        sprint: RaceDateModel(date: '2024-05-25', time: '16:30:00Z'),
        results: null,
        qualifyingResults: null,
        pitStops: null,
      );

      await tester.pumpApp(
        Builder(
          builder: (context) =>
              TextButton(onPressed: () => ScheduleRaceSessionsSheet.show(context, race), child: const Text('open')),
        ),
        surfaceSize: const Size(400, 2000),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Monaco Grand Prix'), findsOneWidget);
      expect(find.text(AppLocalizationsEn().sprint), findsOneWidget);
      expect(find.text(AppLocalizationsEn().sprintQualifying), findsOneWidget);
    });
  });

  group('WeekendScoreboardSection branches', () {
    testWidgets('uses event name when shortName empty and winner label', (tester) async {
      final event = EspnScoreboardEvent(
        name: 'Full Grand Prix Name',
        shortName: '',
        statusState: 'post',
        statusDetail: '',
        circuitName: 'Somewhere',
        circuitCountry: 'Italy',
        sessions: [
          EspnScoreboardSession(
            abbreviation: 'Race',
            statusState: 'post',
            statusDetail: 'Final',
            leaderName: 'Max Verstappen',
            isWinner: true,
          ),
        ],
      );

      await tester.pumpApp(
        ProviderScope(
          child: SingleChildScrollView(
            child: WeekendScoreboardSection(
              scoreboardForTest: Loadable.value(value: event),
              localeForTest: const Locale('en'),
            ),
          ),
        ),
      );

      expect(find.text('Full Grand Prix Name'), findsOneWidget);
      expect(find.text(AppLocalizationsEn().homeWeekendWinner('Max Verstappen')), findsOneWidget);
      expect(find.text('Final'), findsWidgets);
    });
  });

  group('TournamentConstructorsTable roster', () {
    testWidgets('builds with passCurrentRoster', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: TournamentConstructorsTable(
            constructors: WidgetFixtures.constructorsStandings,
            driversStandings: WidgetFixtures.driversStandings,
            passCurrentRoster: true,
          ),
        ),
      );

      expect(find.text('Red Bull'), findsOneWidget);
    });
  });

  group('H2hFiltersCard year picker', () {
    testWidgets('shows season picker when enabled', (tester) async {
      final year = TextEditingController(text: '2024');
      addTearDown(year.dispose);

      await tester.pumpApp(
        SingleChildScrollView(
          child: H2hFiltersCard(
            scopeMode: 1,
            useCurrentSeason: false,
            currentEntitiesOnly: false,
            isSeasonScope: true,
            showYearPicker: true,
            latestSeason: '2025',
            yearController: year,
            entitiesFilterLabel: 'Drivers',
            currentEntitiesTitle: 'Current',
            allEntitiesTitle: 'All',
            onScopeModeChanged: (_) {},
            onUseCurrentSeasonChanged: (_) {},
            onCurrentEntitiesOnlyChanged: (_) {},
            onSeasonChanged: () {},
          ),
        ),
      );

      expect(find.text('2024'), findsOneWidget);
    });
  });
}
