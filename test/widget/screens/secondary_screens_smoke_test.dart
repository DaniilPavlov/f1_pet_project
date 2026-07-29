import 'package:f1_pet_project/common/utils/platform_capabilities.dart';
import 'package:f1_pet_project/core/circuits/screens/circuits_screen.dart';
import 'package:f1_pet_project/core/results/finish_status/screens/finish_status_screen.dart';
import 'package:f1_pet_project/core/results/h2h/screens/h2h_constructors_screen.dart';
import 'package:f1_pet_project/core/results/h2h/screens/h2h_screen.dart';
import 'package:f1_pet_project/core/results/hall_of_fame/screens/hall_of_fame_screen.dart';
import 'package:f1_pet_project/core/results/race_info/screens/race_info_screen.dart';
import 'package:f1_pet_project/core/results/race_search/screens/race_search_screen.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/screen_smoke.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PlatformCapabilities.debugHasYandexMapOverride = false;
  });

  tearDown(() {
    PlatformCapabilities.debugHasYandexMapOverride = null;
  });

  group('secondary screens smoke', () {
    testWidgets('H2hScreen builds filters', (tester) async {
      await tester.pumpScreenSmoke(const H2hScreen());

      expect(find.byType(H2hScreen), findsOneWidget);
      expect(find.text(AppLocalizationsEn().h2hTitle), findsOneWidget);
      expect(find.textContaining(AppLocalizationsEn().h2hSubtitle.split('.').first), findsWidgets);
    });

    testWidgets('H2hConstructorsScreen builds filters', (tester) async {
      await tester.pumpScreenSmoke(const H2hConstructorsScreen());

      expect(find.byType(H2hConstructorsScreen), findsOneWidget);
      expect(find.text(AppLocalizationsEn().h2hConstructorsTitle), findsOneWidget);
    });

    testWidgets('FinishStatusScreen shows statuses', (tester) async {
      await tester.pumpScreenSmoke(const FinishStatusScreen());

      expect(find.byType(FinishStatusScreen), findsOneWidget);
      expect(find.text('Finished'), findsOneWidget);
      expect(find.text('Retired'), findsOneWidget);
    });

    testWidgets('HallOfFameScreen shows standings', (tester) async {
      await tester.pumpScreenSmoke(const HallOfFameScreen());

      expect(find.byType(HallOfFameScreen), findsOneWidget);
      expect(find.text(AppLocalizationsEn().hallOfFameTitle), findsOneWidget);
      expect(find.textContaining('Verstappen'), findsWidgets);
    });

    testWidgets('RaceInfoScreen loads race details', (tester) async {
      await tester.pumpScreenSmoke(RaceInfoScreen(raceModel: ControllerFixtures.race));

      expect(find.byType(RaceInfoScreen), findsOneWidget);
      expect(find.text(AppLocalizationsEn().detailedInfo), findsOneWidget);
    });

    testWidgets('RaceSearchScreen builds search form', (tester) async {
      await tester.pumpScreenSmoke(const RaceSearchScreen());

      expect(find.byType(RaceSearchScreen), findsOneWidget);
      expect(find.text(AppLocalizationsEn().raceSearchTitle), findsOneWidget);
    });

    testWidgets('CircuitsScreen shows list without map', (tester) async {
      await tester.pumpScreenSmoke(const CircuitsScreen());

      expect(find.byType(CircuitsScreen), findsOneWidget);
      expect(find.textContaining('Monaco'), findsWidgets);
    });
  });
}
