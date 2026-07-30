import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LocaleController', () {
    test('defaults to Russian', () {
      final controller = LocaleController();
      expect(controller.locale, const Locale('ru'));
      expect(controller.isRussian, isTrue);
      expect(controller.localeCodeLabel, 'RU');
      expect(controller.isLoaded, isFalse);
      expect(LocaleControllerBase.supportedLocales, [const Locale('ru'), const Locale('en')]);
    });

    test('load and toggle persist locale', () async {
      SharedPreferences.setMockInitialValues({'app_locale': 'en'});
      final controller = LocaleController();

      await controller.load();
      expect(controller.locale, const Locale('en'));
      expect(controller.isRussian, isFalse);
      expect(controller.localeCodeLabel, 'EN');
      expect(controller.isLoaded, isTrue);

      await controller.toggle();
      expect(controller.locale, const Locale('ru'));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_locale'), 'ru');

      await controller.setLocale(const Locale('ru')); // no-op
      expect(prefs.getString('app_locale'), 'ru');
    });
  });
}
