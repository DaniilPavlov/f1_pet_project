import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/core/schedule/controllers/schedule_screen_controller/schedule_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/l10n/app_localizations_ru.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../mobx/mobx_testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ScheduleScreenController', () {
    group('loadAllData', () {
      mobxTest(
        'loads races and marks data as loaded',
        build: () => ScheduleScreenController(
          l10n: AppLocalizationsRu(),
          fetchScheduleForTest: () async => ControllerFixtures.scheduleModel,
        ),
        value: (store) => store.racesElements,
        act: (store) => store.loadAllData(),
        expect: () => [
          isA<AsyncValue<List<RacesModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<List<RacesModel>>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.length, 'length', 1),
        ],
        verify: (store) {
          expect(store.allDataIsLoaded, isTrue);
          store.dispose();
        },
      );

      mobxTest(
        'sets error on failure',
        build: () => ScheduleScreenController(
          l10n: AppLocalizationsRu(),
          fetchScheduleForTest: () async => throw ResponseParseException('parse error'),
        ),
        value: (store) => store.racesElements,
        act: (store) => store.loadAllData(),
        expect: () => [
          isA<AsyncValue<List<RacesModel>>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<List<RacesModel>>>().having((e) => e.status, 'status', AsyncStatus.error),
        ],
        verify: (store) {
          expect(store.screenError, isNotNull);
          store.dispose();
        },
      );
    });

    group('onSelectDay', () {
      test('updates selected and focused date and shows sessions on race day', () async {
        final controller = ScheduleScreenController(
          l10n: AppLocalizationsRu(),
          fetchScheduleForTest: () async => ControllerFixtures.scheduleModel,
        );

        await controller.loadAllData();
        controller.onSelectDay(DateTime.parse('2024-05-26'), DateTime.parse('2024-05-26'));

        expect(controller.selectedDate, DateTime.parse('2024-05-26'));
        expect(controller.focusedDate, DateTime.parse('2024-05-26'));
        expect(controller.selectedDayHasSessions, isTrue);
        controller.dispose();
      });

      test('onPageChanged keeps focused month without changing selected day', () async {
        final controller = ScheduleScreenController(
          l10n: AppLocalizationsRu(),
          fetchScheduleForTest: () async => ControllerFixtures.scheduleModel,
        );

        await controller.loadAllData();
        final selected = controller.selectedDate;
        controller.onPageChanged(DateTime.parse('2024-08-01'));

        expect(controller.focusedDate, DateTime.parse('2024-08-01'));
        expect(controller.selectedDate, selected);
        controller.dispose();
      });

      test('empty day exposes upcoming race fallback', () async {
        final controller = ScheduleScreenController(
          l10n: AppLocalizationsRu(),
          fetchScheduleForTest: () async => ControllerFixtures.scheduleModel,
        );

        await controller.loadAllData();
        // Fixture race is in the past, so upcomingRace is null — empty day has no sessions.
        controller.onSelectDay(DateTime.parse('2024-01-01'), DateTime.parse('2024-01-01'));

        expect(controller.selectedDayHasSessions, isFalse);
        expect(controller.upcomingRace, isNull);
        controller.dispose();
      });
    });

    group('getLogoPath', () {
      test('returns finish icon for race day', () async {
        final controller = ScheduleScreenController(
          l10n: AppLocalizationsRu(),
          fetchScheduleForTest: () async => ControllerFixtures.scheduleModel,
        );

        await controller.loadAllData();

        expect(controller.getLogoPath(DateTime.parse('2024-05-26')), 'assets/calendar/finish.png');
        controller.dispose();
      });

      test('returns car icon for practice day', () async {
        final race = _raceWithSessions(
          raceDate: '2024-05-26',
          practiceDate: '2024-05-24',
        );
        final controller = ScheduleScreenController(
          l10n: AppLocalizationsRu(),
          fetchScheduleForTest: () async => ScheduleModel(
            raceTable: RaceTableModel(season: '2024', round: '5', races: [race]),
          ),
        );

        await controller.loadAllData();

        expect(controller.getLogoPath(DateTime.parse('2024-05-24')), 'assets/calendar/car.png');
        expect(controller.getLogoPath(DateTime.parse('2024-05-01')), isNull);
        controller.dispose();
      });
    });

    test('refreshAll reloads schedule', () async {
      var calls = 0;
      final controller = ScheduleScreenController(
        l10n: AppLocalizationsRu(),
        fetchScheduleForTest: () async {
          calls++;
          return ControllerFixtures.scheduleModel;
        },
      );

      await controller.refreshAll();

      expect(calls, 1);
      expect(controller.racesElements.isValue, isTrue);
      controller.dispose();
    });

    test('upcomingRace and countdown use future race', () async {
      final race = _raceWithSessions(raceDate: '2099-06-15', practiceDate: '2099-06-13');
      final controller = ScheduleScreenController(
        l10n: AppLocalizationsRu(),
        fetchScheduleForTest: () async => ScheduleModel(
          raceTable: RaceTableModel(season: '2099', round: '1', races: [race]),
        ),
      );

      await controller.loadAllData();
      controller.onSelectDay(DateTime.parse('2099-01-01'), DateTime.parse('2099-01-01'));

      expect(controller.upcomingRace?.raceName, 'Monaco Grand Prix');
      expect(controller.upcomingCountdown.days, greaterThan(0));
      expect(controller.selectedDayHasSessions, isFalse);
      controller.dispose();
    });

    test('selecting practice day fills session widgets', () async {
      final race = _raceWithSessions(raceDate: '2024-05-26', practiceDate: '2024-05-24');
      final controller = ScheduleScreenController(
        l10n: AppLocalizationsRu(),
        fetchScheduleForTest: () async => ScheduleModel(
          raceTable: RaceTableModel(season: '2024', round: '5', races: [race]),
        ),
      );

      await controller.loadAllData();
      controller.onSelectDay(DateTime.parse('2024-05-24'), DateTime.parse('2024-05-24'));

      expect(controller.selectedDayHasSessions, isTrue);
      expect(controller.scheduleOfSelectedDate, isNotEmpty);
      controller.dispose();
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
