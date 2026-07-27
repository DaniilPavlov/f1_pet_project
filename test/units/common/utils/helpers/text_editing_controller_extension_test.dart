import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextEditingControllerX.isValidYear', () {
    late TextEditingController controller;

    setUp(() => controller = TextEditingController());
    tearDown(() => controller.dispose());

    test('accepts F1 seasons in range', () {
      controller.text = '2024';
      expect(controller.isValidYear, isTrue);
    });

    test('rejects non-numeric and out-of-range values', () {
      controller.text = 'abcd';
      expect(controller.isValidYear, isFalse);

      controller.text = '1949';
      expect(controller.isValidYear, isFalse);

      controller.text = '2031';
      expect(controller.isValidYear, isFalse);

      controller.text = '24';
      expect(controller.isValidYear, isFalse);
    });
  });

  group('TextEditingControllerX.isValidRound', () {
    late TextEditingController controller;

    setUp(() => controller = TextEditingController());
    tearDown(() => controller.dispose());

    test('accepts rounds 1–99', () {
      controller.text = '1';
      expect(controller.isValidRound, isTrue);

      controller.text = '24';
      expect(controller.isValidRound, isTrue);
    });

    test('rejects invalid rounds', () {
      controller.text = '';
      expect(controller.isValidRound, isFalse);

      controller.text = '0';
      expect(controller.isValidRound, isFalse);

      controller.text = '100';
      expect(controller.isValidRound, isFalse);

      controller.text = 'abc';
      expect(controller.isValidRound, isFalse);
    });
  });
}
