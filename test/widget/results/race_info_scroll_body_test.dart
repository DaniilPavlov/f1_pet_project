import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/results/race_info/components/pit_stops_table_appbar.dart';
import 'package:f1_pet_project/core/results/race_info/components/qualification_table_appbar.dart';
import 'package:f1_pet_project/core/results/race_info/components/race_info_scroll_body.dart';
import 'package:f1_pet_project/core/results/race_info/components/race_info_table_appbar.dart';
import 'package:f1_pet_project/core/results/race_info/controllers/race_info_screen_controller/race_info_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  group('RaceInfoScrollBody', () {
    testWidgets('renders race header and sections', (tester) async {
      final controller = RaceInfoScreenController(
        raceModel: ControllerFixtures.race,
        weekendHasSprintForTest: () async => false,
        fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
      );
      await controller.loadAllData();

      await tester.pumpApp(
        RaceInfoScrollBody(controller: controller),
        surfaceSize: const Size(800, 1400),
        locale: const Locale('ru'),
      );
      await tester.pump(); // avoid pending VisibilityDetector timers

      expect(find.text('Monaco Grand Prix'), findsOneWidget);
      expect(find.textContaining('Verstappen'), findsWidgets);
    });

    testWidgets('includes sprint section when sprint results exist', (tester) async {
      final controller = RaceInfoScreenController(
        raceModel: ControllerFixtures.race,
        weekendHasSprintForTest: () async => true,
        fetchQualifyingResultsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        fetchPitStopsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        fetchSprintResultsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
      );
      await controller.loadAllData();
      controller.sprintResults = AsyncValue.value(value: ControllerFixtures.race.results);

      await tester.pumpApp(
        RaceInfoScrollBody(controller: controller),
        surfaceSize: const Size(800, 1600),
        locale: const Locale('ru'),
      );
      await tester.pump();

      expect(find.text('Monaco Grand Prix'), findsOneWidget);
    });
  });

  group('race info table app bars', () {
    testWidgets('render headers', (tester) async {
      await tester.pumpApp(
        const Column(
          children: [
            SizedBox(height: 48, child: RaceInfoTableAppBar()),
            SizedBox(height: 48, child: QualificationTableAppBar()),
            SizedBox(height: 48, child: PitStopsTableAppBar()),
          ],
        ),
      );

      expect(find.byType(RaceInfoTableAppBar), findsOneWidget);
      expect(find.byType(QualificationTableAppBar), findsOneWidget);
      expect(find.byType(PitStopsTableAppBar), findsOneWidget);
    });
  });
}
