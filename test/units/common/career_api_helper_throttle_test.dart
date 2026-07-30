import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(CareerApiHelper.resetThrottleForTest);

  group('CareerApiHelper.runThrottled', () {
    test('serializes overlapping callers with ≥ minGap between starts', () async {
      final starts = <DateTime>[];

      await Future.wait([
        for (var i = 0; i < 3; i++)
          CareerApiHelper.runThrottled(() async {
            starts.add(DateTime.now());
          }),
      ]);

      expect(starts, hasLength(3));
      expect(
        starts[1].difference(starts[0]),
        greaterThanOrEqualTo(CareerApiHelper.minGap - const Duration(milliseconds: 50)),
      );
      expect(
        starts[2].difference(starts[1]),
        greaterThanOrEqualTo(CareerApiHelper.minGap - const Duration(milliseconds: 50)),
      );
    });
  });
}
