import 'package:f1_pet_project/services/deeplinks/f1pet_deep_links.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('F1PetDeepLinks', () {
    test('driver builds f1pet://driver/<id>', () {
      expect(F1PetDeepLinks.driver('hamilton').toString(), 'f1pet://driver/hamilton');
    });

    test('constructor builds f1pet://constructor/<id>', () {
      expect(F1PetDeepLinks.constructor('mercedes').toString(), 'f1pet://constructor/mercedes');
    });

    test('circuit builds f1pet://circuit/<id>', () {
      expect(F1PetDeepLinks.circuit('monza').toString(), 'f1pet://circuit/monza');
    });

    test('raceLive builds f1pet://race/live', () {
      expect(F1PetDeepLinks.raceLive().toString(), 'f1pet://race/live');
    });

    test('race builds f1pet://race/<season>/<round>', () {
      expect(F1PetDeepLinks.race('2026', '12').toString(), 'f1pet://race/2026/12');
    });
  });
}
