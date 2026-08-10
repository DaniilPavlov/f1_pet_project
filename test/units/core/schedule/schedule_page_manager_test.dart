import 'package:f1_pet_project/common/utils/constants/assets.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/core/schedule/managers/schedule_page_manager.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/core/schedule/providers.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer buildContainer(Future<ScheduleModel> Function() fetch) {
    return ProviderContainer(
      overrides: [
        schedulePageManagerProvider.overrideWith((ref) {
          final manager = SchedulePageManager(
            holder: ref.watch(schedulePageStateHolderProvider.notifier),
            fetchScheduleForTest: fetch,
          );
          ref.onDispose(manager.dispose);
          return manager;
        }),
      ],
    );
  }

  group('SchedulePageManager', () {
    group('loadAllData', () {
      test('loads races and marks data as loaded', () async {
        final container = buildContainer(() async => ControllerFixtures.scheduleModel);
        addTearDown(container.dispose);

        final manager = container.read(schedulePageManagerProvider);
        final pending = manager.loadAllData();
        expect(container.read(schedulePageStateHolderProvider).racesElements.status, LoadableStatus.loading);
        await pending;

        final state = container.read(schedulePageStateHolderProvider);
        expect(state.racesElements.status, LoadableStatus.value);
        expect(state.racesElements.value?.length, 1);
        expect(state.allDataIsLoaded, isTrue);
      });

      test('sets error on failure', () async {
        final container = buildContainer(() async => throw ResponseParseException('parse error'));
        addTearDown(container.dispose);

        await container.read(schedulePageManagerProvider).loadAllData();
        final state = container.read(schedulePageStateHolderProvider);

        expect(state.racesElements.status, LoadableStatus.error);
        expect(state.screenError, isNotNull);
      });
    });

    group('onSelectDay', () {
      test('updates selected and focused date and shows sessions on race day', () async {
        final container = buildContainer(() async => ControllerFixtures.scheduleModel);
        addTearDown(container.dispose);

        final manager = container.read(schedulePageManagerProvider);
        await manager.loadAllData();
        manager.onSelectDay(DateTime.parse('2024-05-26'), DateTime.parse('2024-05-26'));

        final state = container.read(schedulePageStateHolderProvider);
        expect(state.selectedDate, DateTime.parse('2024-05-26'));
        expect(state.focusedDate, DateTime.parse('2024-05-26'));
        expect(state.selectedDayHasSessions, isTrue);
      });

      test('onPageChanged keeps focused month without changing selected day', () async {
        final container = buildContainer(() async => ControllerFixtures.scheduleModel);
        addTearDown(container.dispose);

        final manager = container.read(schedulePageManagerProvider);
        await manager.loadAllData();
        final selected = container.read(schedulePageStateHolderProvider).selectedDate;
        manager.onPageChanged(DateTime.parse('2024-08-01'));

        final state = container.read(schedulePageStateHolderProvider);
        expect(state.focusedDate, DateTime.parse('2024-08-01'));
        expect(state.selectedDate, selected);
      });

      test('empty day exposes upcoming race fallback', () async {
        final container = buildContainer(() async => ControllerFixtures.scheduleModel);
        addTearDown(container.dispose);

        final manager = container.read(schedulePageManagerProvider);
        await manager.loadAllData();
        // Fixture race is in the past, so upcomingRace is null — empty day has no sessions.
        manager.onSelectDay(DateTime.parse('2024-01-01'), DateTime.parse('2024-01-01'));

        final state = container.read(schedulePageStateHolderProvider);
        expect(state.selectedDayHasSessions, isFalse);
        expect(state.upcomingRace, isNull);
      });
    });

    group('getLogoPath', () {
      test('returns finish icon for race day', () async {
        final container = buildContainer(() async => ControllerFixtures.scheduleModel);
        addTearDown(container.dispose);

        final manager = container.read(schedulePageManagerProvider);
        await manager.loadAllData();

        expect(manager.getLogoPath(DateTime.parse('2024-05-26')), Assets.calendar.finish);
      });

      test('returns car icon for practice day', () async {
        final race = _raceWithSessions(raceDate: '2024-05-26', practiceDate: '2024-05-24');
        final container = buildContainer(
          () async => ScheduleModel(
            raceTable: RaceTableModel(season: '2024', round: '5', races: [race]),
          ),
        );
        addTearDown(container.dispose);

        final manager = container.read(schedulePageManagerProvider);
        await manager.loadAllData();

        expect(manager.getLogoPath(DateTime.parse('2024-05-24')), Assets.calendar.car);
        expect(manager.getLogoPath(DateTime.parse('2024-05-01')), isNull);
      });
    });

    test('refreshAll reloads schedule', () async {
      var calls = 0;
      final container = buildContainer(() async {
        calls++;
        return ControllerFixtures.scheduleModel;
      });
      addTearDown(container.dispose);

      await container.read(schedulePageManagerProvider).refreshAll();

      expect(calls, 1);
      expect(container.read(schedulePageStateHolderProvider).racesElements.isValue, isTrue);
    });

    test('upcomingRace and countdown use future race', () async {
      final race = _raceWithSessions(raceDate: '2099-06-15', practiceDate: '2099-06-13');
      final container = buildContainer(
        () async => ScheduleModel(
          raceTable: RaceTableModel(season: '2099', round: '1', races: [race]),
        ),
      );
      addTearDown(container.dispose);

      final manager = container.read(schedulePageManagerProvider);
      await manager.loadAllData();
      manager.onSelectDay(DateTime.parse('2099-01-01'), DateTime.parse('2099-01-01'));

      final state = container.read(schedulePageStateHolderProvider);
      expect(state.upcomingRace?.raceName, 'Monaco Grand Prix');
      expect(state.upcomingCountdown.days, greaterThan(0));
      expect(state.selectedDayHasSessions, isFalse);
    });

    test('selecting practice day fills session data', () async {
      final race = _raceWithSessions(raceDate: '2024-05-26', practiceDate: '2024-05-24');
      final container = buildContainer(
        () async => ScheduleModel(
          raceTable: RaceTableModel(season: '2024', round: '5', races: [race]),
        ),
      );
      addTearDown(container.dispose);

      final manager = container.read(schedulePageManagerProvider);
      await manager.loadAllData();
      manager.onSelectDay(DateTime.parse('2024-05-24'), DateTime.parse('2024-05-24'));

      final state = container.read(schedulePageStateHolderProvider);
      expect(state.selectedDayHasSessions, isTrue);
      expect(state.selectedDay.sessions, isNotEmpty);
      expect(state.selectedDay.raceName, isNotNull);
    });
  });

  group('CountdownParts', () {
    test('splits duration into parts', () {
      final parts = CountdownParts.until(DateTime(2026, 1, 3, 5, 10, 15), DateTime(2026, 1, 1, 2, 0, 0));
      expect(parts.days, 2);
      expect(parts.hours, 3);
      expect(parts.minutes, 10);
      expect(parts.seconds, 15);
    });
  });
}

RacesModel _raceWithSessions({required String raceDate, required String practiceDate}) {
  final base = ControllerFixtures.race;
  return RacesModel(
    season: base.season,
    round: base.round,
    url: base.url,
    raceName: base.raceName,
    circuit: base.circuit,
    date: raceDate,
    time: base.time,
    firstPractice: RaceDateModel(date: practiceDate, time: '12:00:00Z'),
    secondPractice: null,
    thirdPractice: null,
    qualifying: null,
    sprint: null,
    results: base.results,
    qualifyingResults: base.qualifyingResults,
    pitStops: base.pitStops,
  );
}
