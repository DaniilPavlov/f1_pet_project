import 'package:f1_pet_project/common/repositories/wikipedia/wikipedia_page_image_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_dio.dart';

void main() {
  group('WikipediaPageImageRepository', () {
    test('rejects non-wikipedia urls', () async {
      final repo = WikipediaPageImageRepository(dio: fakeDio((_) => throw StateError('no network')));
      expect(await repo.loadThumbnail(articleUrl: ''), isNull);
      expect(await repo.loadThumbnail(articleUrl: 'https://example.com/wiki/Foo'), isNull);
      expect(await repo.loadThumbnail(articleUrl: 'https://en.wikipedia.org/not-wiki/Foo'), isNull);
    });

    test('loads thumbnail and caches', () async {
      var calls = 0;
      final repo = WikipediaPageImageRepository(
        dio: fakeDio((options) {
          calls++;
          expect(options.uri.host, 'en.wikipedia.org');
          expect(options.queryParameters['titles'], 'Monaco_Grand_Prix');
          return {
            'query': {
              'pages': {
                '1': {
                  'thumbnail': {'source': 'https://upload.wikimedia.org/thumb.png'},
                },
              },
            },
          };
        }),
      );

      final url = await repo.loadThumbnail(
        articleUrl: 'https://en.wikipedia.org/wiki/Monaco_Grand_Prix',
      );
      expect(url, 'https://upload.wikimedia.org/thumb.png');

      final again = await repo.loadThumbnail(
        articleUrl: 'https://en.wikipedia.org/wiki/Monaco_Grand_Prix',
      );
      expect(again, url);
      expect(calls, 1);
    });

    test('returns cached result for parallel callers', () async {
      var calls = 0;
      final repo = WikipediaPageImageRepository(
        dio: fakeDio((_) {
          calls++;
          return {
            'query': {
              'pages': {
                '1': {
                  'thumbnail': {'source': 'https://img.png'},
                },
              },
            },
          };
        }),
      );

      final results = await Future.wait([
        repo.loadThumbnail(articleUrl: 'https://en.wikipedia.org/wiki/Spa'),
        repo.loadThumbnail(articleUrl: 'https://en.wikipedia.org/wiki/Spa'),
      ]);

      expect(results[0], 'https://img.png');
      expect(results[1], 'https://img.png');
      expect(calls, lessThanOrEqualTo(2));
    });

    test('returns null when page has no thumbnail or on error', () async {
      final empty = WikipediaPageImageRepository(
        dio: fakeDio((_) => {
          'query': {
            'pages': {
              '1': {'title': 'Missing'},
            },
          },
        }),
      );
      expect(
        await empty.loadThumbnail(articleUrl: 'https://en.wikipedia.org/wiki/Missing'),
        isNull,
      );

      final failing = WikipediaPageImageRepository(
        dio: fakeDio((_) => throw Exception('down')),
      );
      expect(
        await failing.loadThumbnail(articleUrl: 'https://ru.wikipedia.org/wiki/Formula_1'),
        isNull,
      );
    });

    test('clearCache forces refetch', () async {
      var calls = 0;
      final repo = WikipediaPageImageRepository(
        dio: fakeDio((_) {
          calls++;
          return {
            'query': {
              'pages': {
                '1': {
                  'thumbnail': {'source': 'https://img.png'},
                },
              },
            },
          };
        }),
      );

      await repo.loadThumbnail(articleUrl: 'https://en.wikipedia.org/wiki/F1');
      repo.clearCache();
      await repo.loadThumbnail(articleUrl: 'https://en.wikipedia.org/wiki/F1');
      expect(calls, 2);
    });
  });
}
