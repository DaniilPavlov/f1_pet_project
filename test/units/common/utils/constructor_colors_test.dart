import 'package:f1_pet_project/common/utils/constructor_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConstructorColors', () {
    test('returns known team colors', () {
      expect(ConstructorColors.forConstructorId('ferrari'), const Color(0xFF8B0000));
      expect(ConstructorColors.forConstructorId('Mercedes'), const Color(0xFF006F62));
      expect(ConstructorColors.forConstructorId('red_bull'), const Color(0xFF1E2E5A));
      expect(ConstructorColors.forConstructorId('rb'), const Color(0xFF6B9AC4));
      expect(ConstructorColors.forConstructorId('mclaren'), const Color(0xFFFF8700));
      expect(ConstructorColors.forConstructorId('audi'), const Color(0xFFE85A5A));
      expect(ConstructorColors.forConstructorId('cadillac'), const Color(0xFF8A8D8F));
      expect(ConstructorColors.forConstructorId('haas'), const Color(0xFF2B2B2B));
      expect(ConstructorColors.forConstructorId('aston_martin'), const Color(0xFF229971));
      expect(ConstructorColors.forConstructorId('alpine'), const Color(0xFFFF69B4));
      expect(ConstructorColors.forConstructorId('williams'), const Color(0xFF00A0DE));
    });

    test('aliases map to the same known colors', () {
      expect(
        ConstructorColors.forConstructorId('sauber'),
        ConstructorColors.forConstructorId('audi'),
      );
      expect(
        ConstructorColors.forConstructorId('racing_bulls'),
        ConstructorColors.forConstructorId('rb'),
      );
    });

    test('unknown teams get a stable hash fallback', () {
      final a = ConstructorColors.forConstructorId('lotus');
      final b = ConstructorColors.forConstructorId('lotus');
      final c = ConstructorColors.forConstructorId('jordan');

      expect(a, b);
      expect(a, isNot(equals(ConstructorColors.forConstructorId('ferrari'))));
      expect(c, isA<Color>());
    });
  });
}
