import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/core/schedule/controllers/schedule_screen_controller/schedule_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
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
      test('updates selected date and shows sessions on race day', () async {
        final controller = ScheduleScreenController(
          l10n: AppLocalizationsRu(),
          fetchScheduleForTest: () async => ControllerFixtures.scheduleModel,
        );

        await controller.loadAllData();
        controller.onSelectDay(DateTime.parse('2024-05-26'), DateTime.parse('2024-05-26'));

        expect(controller.selectedDate, DateTime.parse('2024-05-26'));
        expect(controller.selectedDayHasSessions, isTrue);
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
    });
  });

  group('CountdownParts', () {
    test('splits duration into parts', () {
      final parts = CountdownParts.until(
        DateTime(2026, 1, 3, 5, 10, 15),
        // ignore: avoid_redundant_argument_values
        DateTime(2026, 1, 1, 2, 0, 0),
      );
      expect(parts.days, 2);
      expect(parts.hours, 3);
      expect(parts.minutes, 10);
      expect(parts.seconds, 15);
    });
  });
}
