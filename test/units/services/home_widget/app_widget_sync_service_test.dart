import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_table_model.dart';
import 'package:f1_pet_project/services/home_widget/app_widget_keys.dart';
import 'package:f1_pet_project/services/home_widget/app_widget_sync_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../helpers/fake_repositories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('com.example.f1_pet_project/app_widgets'),
      null,
    );
  });

  group('AppWidgetSyncService', () {
    test('sync no-ops when platform has no home widgets', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      var called = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('com.example.f1_pet_project/app_widgets'),
        (call) async {
          called = true;
          return null;
        },
      );

      await AppWidgetSyncService(
        scheduleRepository: FakeScheduleRepository(schedule: ControllerFixtures.scheduleModel),
        standingsRepository: FakeCurrentStandingsRepository(drivers: ControllerFixtures.driversStandingsModel),
      ).sync();

      expect(called, isFalse);
    });

    test('sync pushes next GP and standings payload on Android', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      Map<Object?, Object?>? args;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('com.example.f1_pet_project/app_widgets'),
        (call) async {
          expect(call.method, 'saveAndUpdate');
          args = call.arguments as Map<Object?, Object?>?;
          return null;
        },
      );

      final future = DateTime.now().toUtc().add(const Duration(days: 14));
      final date =
          '${future.year.toString().padLeft(4, '0')}-'
          '${future.month.toString().padLeft(2, '0')}-'
          '${future.day.toString().padLeft(2, '0')}';
      final time =
          '${future.hour.toString().padLeft(2, '0')}:'
          '${future.minute.toString().padLeft(2, '0')}:00Z';

      final race = RacesModel(
        season: '2026',
        round: '1',
        url: 'http://example.com',
        raceName: 'Australian Grand Prix',
        circuit: ControllerFixtures.circuit,
        date: date,
        time: time,
        firstPractice: RaceDateModel(date: date, time: time),
        secondPractice: null,
        thirdPractice: null,
        qualifying: null,
        sprint: null,
        results: null,
        qualifyingResults: null,
        pitStops: null,
      );

      await AppWidgetSyncService(
        scheduleRepository: FakeScheduleRepository(
          schedule: ScheduleModel(raceTable: RaceTableModel(season: '2026', round: '1', races: [race])),
        ),
        standingsRepository: FakeCurrentStandingsRepository(drivers: ControllerFixtures.driversStandingsModel),
      ).sync();

      expect(args, isNotNull);
      final data = Map<String, Object?>.from(args!['data']! as Map);
      expect(data[AppWidgetKeys.nextGpHasData], isTrue);
      expect(data[AppWidgetKeys.nextGpRaceName], 'Australian');
      expect(data[AppWidgetKeys.nextGpCircuit], 'Monaco');
      expect(data[AppWidgetKeys.standingsHasData], isTrue);
      expect(data[AppWidgetKeys.driverCode(1)], 'VER');
      expect(data[AppWidgetKeys.driverPoints(1)], '100');
      expect(args!['providers'], [
        AppWidgetKeys.nextGpProvider,
        AppWidgetKeys.standingsProvider,
      ]);
    });

    test('sync marks empty next GP and empty standings', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      Map<Object?, Object?>? args;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('com.example.f1_pet_project/app_widgets'),
        (call) async {
          args = call.arguments as Map<Object?, Object?>?;
          return null;
        },
      );

      final emptyStandings = StandingsModel(
        standingsTable: StandingsTableModel(
          standingsLists: [
            StandingsListsModel(
              season: '2024',
              round: '1',
              driverStandings: const [],
              constructorStandings: null,
            ),
          ],
        ),
      );

      await AppWidgetSyncService(
        scheduleRepository: FakeScheduleRepository(schedule: ControllerFixtures.scheduleModel), // past race
        standingsRepository: FakeCurrentStandingsRepository(drivers: emptyStandings),
      ).sync();

      final data = Map<String, Object?>.from(args!['data']! as Map);
      expect(data[AppWidgetKeys.nextGpHasData], isFalse);
      expect(data[AppWidgetKeys.standingsHasData], isFalse);
    });

    test('sync swallows repository failures', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('com.example.f1_pet_project/app_widgets'),
        (call) async => null,
      );

      await AppWidgetSyncService(
        scheduleRepository: FakeScheduleRepository(throwOnLoad: true),
        standingsRepository: FakeCurrentStandingsRepository(drivers: ControllerFixtures.driversStandingsModel),
      ).sync();
    });
  });
}
