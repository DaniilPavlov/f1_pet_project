import 'package:f1_pet_project/common/repositories/espn/espn_media_repository.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_dio.dart';

void main() {
  Map<String, dynamic> article(int id, {List<Map<String, dynamic>>? categories}) => {
    'id': id,
    'headline': 'Story $id',
    'description': 'd',
    'links': {
      'web': {'href': 'https://espn.com/$id'},
    },
    'categories': ?categories,
  };

  group('EspnMediaRepository', () {
    test('driverCardData searches athlete, loads photo and news, then caches', () async {
      var searchCalls = 0;
      final repo = EspnMediaRepository(
        dio: fakeDio((options) {
          final uri = options.uri.toString();
          if (uri.contains(StaticData.espnSearchUrl) || options.path.contains('search')) {
            searchCalls++;
            return {
              'items': [
                {
                  'id': 123,
                  'displayName': 'Max Verstappen',
                  'sport': 'racing',
                  'league': 'f1',
                },
              ],
            };
          }
          if (uri.contains('/athletes/123') && !uri.contains('overview')) {
            return {
              'headshot': {'href': 'https://a.espncdn.com/i/headshots/rpm/players/full/123.png'},
            };
          }
          if (uri.contains('overview')) {
            return {
              'news': [article(1), article(2)],
            };
          }
          throw StateError('unexpected ${options.uri}');
        }),
      );

      final first = await repo.driverCardData(givenName: 'Max', familyName: 'Verstappen');
      expect(first.photoUrl, contains('123.png'));
      expect(first.news, hasLength(2));

      final photo = await repo.driverPhotoUrl(givenName: 'Max', familyName: 'Verstappen');
      expect(photo, first.photoUrl);
      expect(searchCalls, 1); // second call served from cache
    });

    test('driverCardData returns empty when search misses', () async {
      final repo = EspnMediaRepository(
        dio: fakeDio((_) => {'items': <dynamic>[]}),
      );

      final data = await repo.driverCardData(givenName: 'Unknown', familyName: 'Driver');
      expect(data.photoUrl, isNull);
      expect(data.news, isEmpty);
    });

    test('constructorNews uses mapped team id', () async {
      final repo = EspnMediaRepository(
        dio: fakeDio((options) {
          expect(options.queryParameters['team'], '106921');
          return {
            'articles': [article(9)],
          };
        }),
      );

      final news = await repo.constructorNews(
        constructorId: 'red_bull',
        constructorName: 'Red Bull',
      );
      expect(news.single.id, 9);

      // cache
      final again = await repo.constructorNews(
        constructorId: 'red_bull',
        constructorName: 'Red Bull',
      );
      expect(identical(news, again) || again.single.id == 9, isTrue);
    });

    test('constructorNews falls back to name filter for unknown teams', () async {
      final repo = EspnMediaRepository(
        dio: fakeDio((options) {
          expect(options.queryParameters.containsKey('team'), isFalse);
          return {
            'articles': [
              article(
                1,
                categories: [
                  {'type': 'team', 'description': 'Haas F1 Team'},
                ],
              ),
              article(
                2,
                categories: [
                  {'type': 'team', 'description': 'Ferrari'},
                ],
              ),
            ],
          };
        }),
      );

      final news = await repo.constructorNews(
        constructorId: 'haas',
        constructorName: 'Haas',
      );
      expect(news.map((a) => a.id), [1]);
    });

    test('clearCache forces refetch', () async {
      var calls = 0;
      final repo = EspnMediaRepository(
        dio: fakeDio((_) {
          calls++;
          return {
            'articles': [article(calls)],
          };
        }),
      );

      await repo.constructorNews(constructorId: 'ferrari', constructorName: 'Ferrari');
      repo.clearCache();
      await repo.constructorNews(constructorId: 'ferrari', constructorName: 'Ferrari');
      expect(calls, 2);
    });
  });
}
