import 'package:f1_pet_project/core/results/models/pit_stops_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PitStopsModel', () {
    test('fromJson and copyWith', () {
      final stop = PitStopsModel.fromJson({
        'driverId': 'norris',
        'lap': '12',
        'stop': '1',
        'time': '14:00:00',
        'duration': '2.4',
      });

      expect(stop.driverId, 'norris');
      expect(stop.copyWith(driverId: 'Lando Norris').driverId, 'Lando Norris');
      expect(stop.copyWith().lap, '12');
    });

    test('fromJson throws ResponseParseException on bad payload', () {
      expect(() => PitStopsModel.fromJson(const {}), throwsA(isA<ResponseParseException>()));
    });
  });
}
