import 'dart:async';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/services/cache/prefs_json_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/fake_dio.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Map<String, dynamic> scoreboardPayload() => {
    'events': [
      {
        'name': 'Formula 1 Rolex Belgian Grand Prix 2024',
        'shortName': 'Belgian GP',
        'date': '2024-07-26T13:00Z',
        'endDate': '2024-07-28T15:00Z',
        'status': {
          'type': {'state': 'post', 'shortDetail': 'Final', 'description': 'Final'},
        },
        'circuit': {
          'fullName': 'Circuit de Spa-Francorchamps',
          'address': {'city': 'Spa', 'country': 'Belgium'},
        },
        'competitions': [
          {
            'type': {'abbreviation': 'Race'},
            'date': '2024-07-28T13:00Z',
            'status': {
              'type': {'state': 'post', 'shortDetail': 'Final'},
            },
            'competitors': [
              {
                'order': 2,
                'winner': false,
                'athlete': {
                  'displayName': 'Charles Leclerc',
                  'flag': {'alt': 'Monaco'},
                },
              },
              {
                'order': 1,
                'winner': true,
                'athlete': {
                  'displayName': 'Max Verstappen',
                  'flag': {'alt': 'Netherlands'},
                },
              },
            ],
          },
        ],
      },
    ],
  };

  group('EspnScoreboardRepository', () {
    test('loadEvent parses event, sessions and sorted results', () async {
      var calls = 0;
      final repo = EspnScoreboardRepository(
        dio: fakeDio((options) {
          calls++;
          expect(options.path, StaticData.espnF1ScoreboardUrl);
          return scoreboardPayload();
        }),
        store: const PrefsJsonStore('scoreboard_test_v1'),
      );

      final event = await repo.loadEvent();

      expect(event, isNotNull);
      expect(event!.shortName, 'Belgian GP');
      expect(event.circuitName, 'Circuit de Spa-Francorchamps');
      expect(event.statusDetail, 'Final');
      expect(event.sessions, hasLength(1));
      expect(event.sessions.first.abbreviation, 'Race');
      expect(event.sessions.first.leaderName, 'Max Verstappen');
      expect(event.sessions.first.isWinner, isTrue);
      expect(event.sessions.first.results.map((r) => r.position), [1, 2]);
      expect(repo.isFresh, isTrue);

      await repo.loadEvent();
      expect(calls, 1);
    });

    test('empty events returns null and caches', () async {
      final repo = EspnScoreboardRepository(
        dio: fakeDio((_) => {'events': <dynamic>[]}),
        store: const PrefsJsonStore('scoreboard_empty'),
      );

      expect(await repo.loadEvent(), isNull);
      expect(repo.peek, isNull);
      expect(repo.isFresh, isTrue);
    });

    test('offline falls back to disk after clearCache', () async {
      var fail = false;
      final repo = EspnScoreboardRepository(
        dio: fakeDio((_) {
          if (fail) {
            throw Exception('offline');
          }
          return scoreboardPayload();
        }),
        store: const PrefsJsonStore('scoreboard_offline'),
      );

      await repo.loadEvent();
      fail = true;
      repo.clearCache();

      final event = await repo.loadEvent(forceRefresh: true);
      expect(event?.shortName, 'Belgian GP');
    });

    test('invalidate marks cache stale and forceRefresh refetches', () async {
      var calls = 0;
      final repo = EspnScoreboardRepository(
        dio: fakeDio((_) {
          calls++;
          return scoreboardPayload();
        }),
        store: const PrefsJsonStore('scoreboard_invalidate'),
      );

      await repo.loadEvent();
      repo.invalidate();
      await repo.loadEvent(forceRefresh: true);
      expect(calls, 2);
    });

    test('empty events list returns null', () async {
      final repo = EspnScoreboardRepository(
        dio: fakeDio((_) => {'events': <dynamic>[]}),
        store: const PrefsJsonStore('scoreboard_empty'),
      );

      expect(await repo.loadEvent(), isNull);
    });

    test('uses description and shortName athlete fallbacks', () async {
      final repo = EspnScoreboardRepository(
        dio: fakeDio(
          (_) => {
            'events': [
              {
                'name': 'Test GP',
                'shortName': 'TST',
                'status': {
                  'type': {'state': 'pre', 'description': 'Scheduled'},
                },
                'competitions': [
                  {
                    'type': {'abbreviation': ''},
                    'status': {
                      'type': {'state': 'pre', 'detail': 'Upcoming'},
                    },
                    'competitors': [
                      {
                        'order': '1',
                        'winner': false,
                        'athlete': {'shortName': 'VER'},
                      },
                      {
                        'order': 2,
                        'athlete': {'displayName': ''},
                      },
                    ],
                  },
                ],
              },
            ],
          },
        ),
        store: const PrefsJsonStore('scoreboard_fallbacks'),
      );

      final event = await repo.loadEvent();
      expect(event?.statusDetail, 'Scheduled');
      expect(event?.sessions.single.abbreviation, 'Session');
      expect(event?.sessions.single.statusDetail, 'Upcoming');
      expect(event?.sessions.single.results.single.displayName, 'VER');
    });

    test('rethrows when network fails without cache', () async {
      final repo = EspnScoreboardRepository(
        dio: fakeDio((_) => throw Exception('offline')),
        store: const PrefsJsonStore('scoreboard_fail'),
      );

      await expectLater(repo.loadEvent(), throwsA(isA<Exception>()));
    });

    test('null response body throws ResponseParseException', () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response<Map<String, dynamic>>(requestOptions: options, statusCode: 200),
            );
          },
        ),
      );
      final repo = EspnScoreboardRepository(
        dio: dio,
        store: const PrefsJsonStore('scoreboard_null_body'),
      );

      await expectLater(repo.loadEvent(), throwsA(isA<Exception>()));
    });

    test('coalesces in-flight loads and refreshes stale memory cache', () async {
      var calls = 0;
      final gate = Completer<void>();
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            calls++;
            await gate.future;
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                data: scoreboardPayload(),
                statusCode: 200,
              ),
            );
          },
        ),
      );
      final repo = EspnScoreboardRepository(
        dio: dio,
        store: const PrefsJsonStore('scoreboard_inflight'),
      );

      final first = repo.loadEvent();
      await Future<void>.delayed(Duration.zero);
      final second = repo.loadEvent();
      gate.complete();
      await Future.wait([first, second]);
      expect(calls, 1);

      repo.invalidate();
      await repo.loadEvent();
      expect(calls, 2);
    });
  });
}
