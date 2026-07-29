import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/core/circuits/screens/circuit_screen.dart';
import 'package:f1_pet_project/core/home/screens/home_screen.dart';
import 'package:f1_pet_project/core/news/screens/news_screen.dart';
import 'package:f1_pet_project/core/results/constructor/screens/constructor_screen.dart';
import 'package:f1_pet_project/core/results/driver/screens/driver_screen.dart';
import 'package:f1_pet_project/core/results/screens/results_screen.dart';
import 'package:f1_pet_project/core/schedule/screens/schedule_screen.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/screen_smoke.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('primary screens smoke', () {
    testWidgets('HomeScreen shows standings', (tester) async {
      await tester.pumpScreenSmoke(const HomeScreen());

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.textContaining('Verstappen'), findsWidgets);
    });

    testWidgets('NewsScreen shows articles', (tester) async {
      await tester.pumpScreenSmoke(const NewsScreen());

      expect(find.text('Headline'), findsOneWidget);
      expect(find.text(AppLocalizationsEn().newsTitle), findsOneWidget);
    });

    testWidgets('ScheduleScreen builds', (tester) async {
      await tester.pumpScreenSmoke(const ScheduleScreen());

      expect(find.byType(ScheduleScreen), findsOneWidget);
    });

    testWidgets('ResultsScreen shows last race', (tester) async {
      final live = LiveWeekendController(
        fetchScoreboardForTest: ({bool forceRefresh = false}) async => const EspnScoreboardEvent(
          name: 'Monaco Grand Prix',
          shortName: 'MON',
          statusState: 'post',
          statusDetail: 'Final',
          circuitName: 'Monaco',
          sessions: [],
        ),
      );
      addTearDown(live.dispose);

      await tester.pumpScreenSmoke(
        const ResultsScreen(),
        liveWeekend: live,
        surfaceSize: const Size(800, 2400),
      );

      expect(find.byType(ResultsScreen), findsOneWidget);
      expect(find.textContaining('Monaco'), findsWidgets);
    });

    testWidgets('DriverScreen shows career stats', (tester) async {
      await tester.pumpScreenSmoke(DriverScreen(driver: ControllerFixtures.driver));

      expect(find.textContaining('Verstappen'), findsWidgets);
      expect(find.text(AppLocalizationsEn().careerTitle), findsOneWidget);
    });

    testWidgets('ConstructorScreen shows career stats', (tester) async {
      await tester.pumpScreenSmoke(ConstructorScreen(constructor: ControllerFixtures.constructor));

      expect(find.text('Red Bull'), findsWidgets);
      expect(find.text(AppLocalizationsEn().careerTitle), findsOneWidget);
    });

    testWidgets('CircuitScreen shows circuit info', (tester) async {
      await tester.pumpScreenSmoke(CircuitScreen(circuitModel: ControllerFixtures.circuit));

      expect(find.byType(CircuitScreen), findsOneWidget);
      expect(find.textContaining('Monaco'), findsWidgets);
    });
  });
}
