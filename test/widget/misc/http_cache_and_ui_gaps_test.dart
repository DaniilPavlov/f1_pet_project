import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/widgets/share/share_race_results_card.dart';
import 'package:f1_pet_project/core/results/components/weekend_scoreboard_section.dart';
import 'package:f1_pet_project/core/results/components/weekend_session_results_sheet.dart';
import 'package:f1_pet_project/core/results/h2h/components/h2h_points_chart.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_round_score.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:f1_pet_project/services/cache/prefs_json_store.dart';
import 'package:f1_pet_project/services/http/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/fake_request_handler.dart';
import '../../helpers/jolpica_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppDio', () {
    test('jolpica and external create configured clients', () {
      final jolpica = AppDio.jolpica();
      expect(jolpica.options.baseUrl, isNotEmpty);
      expect(jolpica.options.connectTimeout, AppDio.connectTimeout);

      final external = AppDio.external(headers: {'X-Test': '1'});
      expect(external.options.baseUrl, isEmpty);
      expect(external.options.headers['X-Test'], '1');
      expect(external.options.connectTimeout, AppDio.espnConnectTimeout);
    });
  });

  group('BaseResponseModel', () {
    test('fromJson / toJson round-trip and parse error', () {
      final model = BaseResponseModel.fromJson({
        'MRData': {'xmlns': 'http://example.com'},
        'message': 'ok',
        'code': 200,
      });
      expect(model.mrData, isA<Map>());
      expect(model.toJson()['MRData'], isNotNull);

      expect(
        () => BaseResponseModel.fromJson({'MRData': {}, 'message': 123}),
        throwsA(isA<ResponseParseException>()),
      );
    });
  });

  group('SeasonsRepository cache helpers', () {
    setUp(() {
      CareerApiHelper.resetThrottleForTest();
      SharedPreferences.setMockInitialValues({});
    });

    test('coalesces in-flight getSeasonYears and clearCache', () async {
      var calls = 0;
      ApiLoader.configure(
        FakeRequestHandler(
          resolver: (path, limit, offset) {
            calls++;
            return {'MRData': JolpicaFixtures.seasonsMrData()};
          },
        ),
      );

      final repo = SeasonsRepository(
        store: const DayPrefsJsonStore(dataKey: 'seasons_inflight', dateKey: 'seasons_inflight_date'),
      );

      final results = await Future.wait([repo.getSeasonYears(), repo.getSeasonYears()]);
      expect(results[0], results[1]);
      expect(calls, 1);

      await repo.clearCache();
      repo.invalidate();
      await repo.getSeasonYears();
      expect(calls, 2);
    });
  });

  group('DayPrefsJsonStore decode', () {
    test('corrupt json returns null', () async {
      SharedPreferences.setMockInitialValues({});
      const store = DayPrefsJsonStore(dataKey: 'day_corrupt', dateKey: 'day_corrupt_date');
      await store.writeToday({'ok': true});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('day_corrupt', 'not-json');

      expect(await store.readToday(), isNull);
      expect(await store.readAny(), isNull);
    });
  });

  group('H2hPointsChart denser timelines', () {
    List<H2hRoundScore> scores(int n, {required double base}) => [
      for (var i = 1; i <= n; i++)
        H2hRoundScore(season: '2024', round: '$i', raceName: 'R$i', points: base),
    ];

    testWidgets('paints single-point and dense timelines', (tester) async {
      final single = H2hPointsTimeline.fromScores(
        scoresA: scores(1, base: 25),
        scoresB: scores(1, base: 18),
        seasonScope: '2024',
      );
      await tester.pumpApp(
        H2hPointsChart(timeline: single, colorA: Colors.red, colorB: Colors.blue),
        surfaceSize: const Size(390, 280),
      );

      for (final n in [10, 20, 40]) {
        final timeline = H2hPointsTimeline.fromScores(
          scoresA: scores(n, base: 10),
          scoresB: scores(n, base: 8),
          seasonScope: '2024',
        );
        await tester.pumpApp(
          H2hPointsChart(timeline: timeline, colorA: Colors.red, colorB: Colors.blue),
          surfaceSize: const Size(390, 280),
        );
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _RepaintChartHost(timeline: single),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('flip'));
      await tester.pump();
      expect(find.byType(H2hPointsChart), findsOneWidget);
    });
  });

  group('ShareRaceResultsCard overflow label', () {
    testWidgets('shows and-more when results exceed topN', (tester) async {
      final base = ControllerFixtures.race;
      final many = List.generate(12, (_) => ControllerFixtures.raceResult);
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
        results: many,
        qualifyingResults: null,
        pitStops: null,
      );

      final l10n = AppLocalizationsEn();
      await tester.pumpApp(
        SingleChildScrollView(child: ShareRaceResultsCard(l10n: l10n, race: race, topN: 10)),
      );

      expect(find.text(l10n.shareAndMore(2)), findsOneWidget);
    });
  });

  group('WeekendScoreboardSection opens session sheet', () {
    testWidgets('tapping a session opens WeekendSessionResultsSheet', (tester) async {
      final event = EspnScoreboardEvent(
        name: 'Monaco Grand Prix',
        shortName: 'MON',
        statusState: 'post',
        statusDetail: 'Final',
        circuitName: 'Monaco',
        sessions: const [
          EspnScoreboardSession(
            abbreviation: 'Race',
            statusState: 'post',
            statusDetail: 'Final',
            results: [
              EspnScoreboardResultEntry(position: 1, displayName: 'Max Verstappen', isWinner: true),
            ],
          ),
        ],
      );

      await tester.pumpApp(
        SingleChildScrollView(
          child: WeekendScoreboardSection(
            scoreboard: AsyncValue.value(value: event),
            locale: const Locale('en'),
          ),
        ),
        surfaceSize: const Size(400, 2000),
      );

      await tester.tap(find.text('Race').first);
      await tester.pumpAndSettle();

      expect(find.byType(WeekendSessionResultsSheet), findsOneWidget);
      expect(find.text('Max Verstappen'), findsOneWidget);
    });
  });
}

class _RepaintChartHost extends StatefulWidget {
  const _RepaintChartHost({required this.timeline});

  final H2hPointsTimeline timeline;

  @override
  State<_RepaintChartHost> createState() => _RepaintChartHostState();
}

class _RepaintChartHostState extends State<_RepaintChartHost> {
  var _alt = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(onPressed: () => setState(() => _alt = !_alt), child: const Text('flip')),
        Expanded(
          child: H2hPointsChart(
            timeline: widget.timeline,
            colorA: _alt ? Colors.green : Colors.red,
            colorB: _alt ? Colors.orange : Colors.blue,
          ),
        ),
      ],
    );
  }
}
