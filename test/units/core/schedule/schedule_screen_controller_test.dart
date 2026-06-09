import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/schedule/controllers/schedule_screen_controller/schedule_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
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
          fetchSchedule: () async => ControllerFixtures.scheduleModel,
        ),
        value: (store) => store.racesElements,
        act: (store) => store.loadAllData(),
        expect: () => [
          isA<AsyncValue<List<RacesModel>>>().having(
            (e) => e.status,
            'status',
            AsyncStatus.loading,
          ),
          isA<AsyncValue<List<RacesModel>>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.length, 'length', 1),
        ],
        verify: (store) {
          expect(store.allDataIsLoaded, isTrue);
        },
      );

      mobxTest(
        'sets error on failure',
        build: () => ScheduleScreenController(
          fetchSchedule: () async => throw ResponseParseException('parse error'),
        ),
        value: (store) => store.racesElements,
        act: (store) => store.loadAllData(),
        expect: () => [
          isA<AsyncValue<List<RacesModel>>>().having(
            (e) => e.status,
            'status',
            AsyncStatus.loading,
          ),
          isA<AsyncValue<List<RacesModel>>>().having(
            (e) => e.status,
            'status',
            AsyncStatus.error,
          ),
        ],
        verify: (store) {
          expect(store.screenError, isNotNull);
        },
      );
    });

    group('onSelectDay', () {
      test('updates selected date', () async {
        final controller = ScheduleScreenController(
          fetchSchedule: () async => ControllerFixtures.scheduleModel,
        );

        await controller.loadAllData();
        controller.onSelectDay(DateTime.parse('2024-05-26'), DateTime.parse('2024-05-26'));

        expect(controller.selectedDate, DateTime.parse('2024-05-26'));
      });
    });

    group('getLogoPath', () {
      test('returns finish icon for race day', () async {
        final controller = ScheduleScreenController(
          fetchSchedule: () async => ControllerFixtures.scheduleModel,
        );

        await controller.loadAllData();

        expect(
          controller.getLogoPath(DateTime.parse('2024-05-26')),
          'assets/calendar/finish.png',
        );
      });
    });
  });
}
