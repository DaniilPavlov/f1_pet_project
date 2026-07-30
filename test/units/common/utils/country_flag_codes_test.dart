import 'package:f1_pet_project/common/utils/country_flag_codes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountryFlagCodes', () {
    test('resolve maps nationality and country names', () {
      expect(CountryFlagCodes.resolve(null), isNull);
      expect(CountryFlagCodes.resolve('  '), isNull);
      expect(CountryFlagCodes.resolve('British'), 'gb');
      expect(CountryFlagCodes.resolve('monaco'), 'mc');
      expect(CountryFlagCodes.resolve('unknownland'), isNull);
    });

    test('toEmoji builds regional indicator pairs', () {
      expect(CountryFlagCodes.toEmoji('gb'), '🇬🇧');
      expect(CountryFlagCodes.toEmoji('g'), isEmpty);
      expect(CountryFlagCodes.toEmoji('gbr'), isEmpty);
    });
  });
}
