import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/race_info/controllers/race_info_screen_controller/race_info_screen_controller.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../mobx/mobx_testing.dart';

void main() {
  group('RaceInfoScreenController', () {
    group('loadQualifyingResults', () {
      mobxTest(
        'sets value on success',
        build: () => RaceInfoScreenController(
          raceModel: ControllerFixtures.race,
          fetchQualifyingResults: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        ),
        value: (store) => store.qualifyingResults,
        act: (store) => store.loadQualifyingResults(),
        expect: () => [
          isA<AsyncValue<List<QualifyingResultsModel>>>().having(
            (e) => e.status,
            'status',
            AsyncStatus.loading,
          ),
          isA<AsyncValue<List<QualifyingResultsModel>>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.length, 'length', 1),
        ],
      );

      mobxTest(
        'sets error on failure',
        build: () => RaceInfoScreenController(
          raceModel: ControllerFixtures.race,
          fetchQualifyingResults: ({required year, required round}) async => throw ResponseParseException('parse error'),
        ),
        value: (store) => store.qualifyingResults,
        act: (store) => store.loadQualifyingResults(),
        expect: () => [
          isA<AsyncValue<List<QualifyingResultsModel>>>().having(
            (e) => e.status,
            'status',
            AsyncStatus.loading,
          ),
          isA<AsyncValue<List<QualifyingResultsModel>>>().having(
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

    group('visibility callbacks', () {
      mobxTest(
        'unpins race app bar when table is scrolled away',
        build: () => RaceInfoScreenController(raceModel: ControllerFixtures.race),
        value: (store) => store.raceAppBarPinned,
        act: (store) {
          store.onRaceTableVisibilityChanged(
            const VisibilityInfo(
              key: Key('race'),
              size: Size(300, 400),
              visibleBounds: Rect.fromLTWH(0, 300, 300, 100),
            ),
          );
        },
        expect: () => [true, false],
      );

      mobxTest(
        'pins qualification app bar when table is scrolled',
        build: () => RaceInfoScreenController(raceModel: ControllerFixtures.race),
        value: (store) => store.qualificationAppBarPinned,
        act: (store) {
          store.onQualificationTableVisibilityChanged(
            const VisibilityInfo(
              key: Key('qualifying'),
              size: Size(300, 400),
              visibleBounds: Rect.fromLTWH(0, 100, 300, 200),
            ),
          );
        },
        expect: () => [false, true],
      );
    });

    group('loadAllData', () {
      mobxTest(
        'marks data as loaded',
        build: () => RaceInfoScreenController(
          raceModel: ControllerFixtures.race,
          fetchQualifyingResults: ({required year, required round}) async => ControllerFixtures.scheduleModel,
          fetchPitStops: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        ),
        value: (store) => store.allDataIsLoaded,
        act: (store) => store.loadAllData(),
        expect: () => [false, true],
      );
    });
  });
}
