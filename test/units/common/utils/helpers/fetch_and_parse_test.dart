import 'package:f1_pet_project/common/utils/helpers/fetch_and_parse.dart';
import 'package:f1_pet_project/data/models/baseResponse/base_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fetchAndParse', () {
    test('parses MRData from load', () async {
      final result = await fetchAndParse<String>(
        load: () async => const BaseResponseModel(mrData: {'value': 'ok'}),
        parse: (json) => json['value'] as String,
      );

      expect(result, 'ok');
    });

    test('uses wrap strategy when provided', () async {
      var wrapped = false;
      final result = await fetchAndParse<int>(
        load: () async => const BaseResponseModel(mrData: {'n': 1}),
        parse: (json) => json['n'] as int,
        wrap: (load) async {
          wrapped = true;
          return load();
        },
      );

      expect(wrapped, isTrue);
      expect(result, 1);
    });
  });
}
