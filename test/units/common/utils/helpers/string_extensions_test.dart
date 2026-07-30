import 'package:f1_pet_project/common/utils/helpers/string_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtensions', () {
    test('capitalize uppercases first letter', () {
      expect('hello'.capitalize(), 'Hello');
      expect('HELLO'.capitalize(), 'Hello');
    });

    test('truncateWithEllipsis shortens long strings', () {
      expect('abc'.truncateWithEllipsis(5), 'abc');
      expect('abcdef'.truncateWithEllipsis(3), 'abc.');
    });
  });
}
