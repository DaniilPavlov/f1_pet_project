import 'dart:async';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/services/cache/prefs_json_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Map<String, dynamic> espnPayload([int id = 1]) => {
    'articles': [
      {
        'id': id,
        'headline': 'Headline $id',
        'description': 'Desc',
        'links': {
          'web': {'href': 'https://www.espn.com/f1/story/$id'},
        },
      },
    ],
  };

  Dio dioWith(Object Function(RequestOptions) bodyOrError) {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          try {
            final body = bodyOrError(options);
            if (body is Exception) {
              handler.reject(DioException(requestOptions: options, error: body, type: DioExceptionType.unknown));
              return;
            }
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                data: body as Map<String, dynamic>,
                statusCode: 200,
              ),
            );
          } on Object catch (e) {
            handler.reject(DioException(requestOptions: options, error: e, type: DioExceptionType.unknown));
          }
        },
      ),
    );
    return dio;
  }

  group('NewsRepository', () {
    test('loadArticles fetches, caches in memory and on disk', () async {
      var calls = 0;
      final repo = NewsRepository(
        dio: dioWith((_) {
          calls++;
          return espnPayload();
        }),
        store: const PrefsJsonStore('news_test_v1'),
      );

      final first = await repo.loadArticles();
      expect(first.single.headline, 'Headline 1');
      expect(repo.isFresh, isTrue);
      expect(repo.peek, hasLength(1));

      final second = await repo.loadArticles();
      expect(identical(first, second) || second.single.id == 1, isTrue);
      expect(calls, 1);
      expect(StaticData.espnF1NewsUrl, contains('espn.com'));
    });

    test('forceRefresh hits network again', () async {
      var calls = 0;
      final repo = NewsRepository(
        dio: dioWith((_) {
          calls++;
          return espnPayload(calls);
        }),
        store: const PrefsJsonStore('news_test_force'),
      );

      await repo.loadArticles();
      final refreshed = await repo.loadArticles(forceRefresh: true);

      expect(calls, 2);
      expect(refreshed.single.id, 2);
    });

    test('network failure returns disk/memory cache', () async {
      var fail = false;
      final repo = NewsRepository(
        dio: dioWith((_) {
          if (fail) {
            throw Exception('offline');
          }
          return espnPayload(7);
        }),
        store: const PrefsJsonStore('news_test_offline'),
      );

      await repo.loadArticles();
      fail = true;
      repo
        ..invalidate()
        ..clearCache();

      // Disk still has payload from first write.
      final articles = await repo.loadArticles(forceRefresh: true);
      expect(articles.single.id, 7);
    });

    test('skips articles without headline or url', () async {
      final repo = NewsRepository(
        dio: dioWith(
          (_) => {
            'articles': [
              {
                'id': 1,
                'headline': '',
                'description': 'x',
                'links': {
                  'web': {'href': 'https://espn.com/1'},
                },
              },
              {
                'id': 2,
                'headline': 'Ok',
                'description': 'x',
                'links': {
                  'web': {'href': 'https://espn.com/2'},
                },
              },
            ],
          },
        ),
        store: const PrefsJsonStore('news_test_filter'),
      );

      final articles = await repo.loadArticles();
      expect(articles, hasLength(1));
      expect(articles.single.headline, 'Ok');
    });

    test('shares in-flight after disk ensure', () async {
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
                data: espnPayload(),
                statusCode: 200,
              ),
            );
          },
        ),
      );
      final repo = NewsRepository(dio: dio, store: const PrefsJsonStore('news_test_inflight'));

      final first = repo.loadArticles();
      await Future<void>.delayed(Duration.zero);
      final second = repo.loadArticles();
      gate.complete();
      final results = await Future.wait([first, second]);

      expect(results[0].single.id, 1);
      expect(results[1].single.id, 1);
      expect(calls, 1);
    });

    test('rethrows when network fails without any cache', () async {
      final repo = NewsRepository(
        dio: dioWith((_) => throw Exception('offline')),
        store: const PrefsJsonStore('news_test_empty_fail'),
      );

      await expectLater(repo.loadArticles(), throwsA(isA<DioException>()));
    });

    test('throws on missing articles key', () async {
      final repo = NewsRepository(
        dio: dioWith((_) => <String, dynamic>{'articles': 'bad'}),
        store: const PrefsJsonStore('news_test_bad_shape'),
      );

      await expectLater(repo.loadArticles(), throwsA(isA<Exception>()));
    });

    test('null response body and stale-while-revalidate path', () async {
      var calls = 0;
      final repo = NewsRepository(
        dio: dioWith((_) {
          calls++;
          return espnPayload(3);
        }),
        store: const PrefsJsonStore('news_test_null_stale'),
      );

      await repo.loadArticles();
      expect(calls, 1);

      repo.invalidate();
      await repo.loadArticles();
      expect(calls, 2);

      final nullDio = Dio();
      nullDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response<Map<String, dynamic>>(requestOptions: options, statusCode: 200),
            );
          },
        ),
      );
      final nullRepo = NewsRepository(dio: nullDio, store: const PrefsJsonStore('news_test_null_body'));
      await expectLater(nullRepo.loadArticles(), throwsA(isA<Exception>()));
    });
  });
}
