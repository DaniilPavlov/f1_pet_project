import 'package:f1_pet_project/common/utils/trusted_url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TrustedUrl.parse', () {
    test('accepts https wikipedia links', () {
      expect(
        TrustedUrl.parse('https://en.wikipedia.org/wiki/Monaco_Grand_Prix')?.toString(),
        'https://en.wikipedia.org/wiki/Monaco_Grand_Prix',
      );
    });

    test('upgrades http to https for allowed hosts', () {
      expect(
        TrustedUrl.parse('http://en.wikipedia.org/wiki/Monaco_Grand_Prix')?.toString(),
        'https://en.wikipedia.org/wiki/Monaco_Grand_Prix',
      );
    });

    test('accepts espn and github', () {
      expect(
        TrustedUrl.parse('https://www.espn.com/f1/story/_/id/123')?.host,
        'www.espn.com',
      );
      expect(
        TrustedUrl.parse('https://github.com/DaniilPavlov/f1_pet_project/releases')?.host,
        'github.com',
      );
    });

    test('rejects unknown hosts and non-http(s) schemes', () {
      expect(TrustedUrl.parse('http://example.com/page'), isNull);
      expect(TrustedUrl.parse('javascript:alert(1)'), isNull);
      expect(TrustedUrl.parse(''), isNull);
    });

    test('preferHttps upgrades http without host check', () {
      expect(
        TrustedUrl.preferHttps('http://cdn.example.com/img.jpg'),
        'https://cdn.example.com/img.jpg',
      );
      expect(TrustedUrl.preferHttps('https://cdn.example.com/img.jpg'), 'https://cdn.example.com/img.jpg');
    });
  });
}
