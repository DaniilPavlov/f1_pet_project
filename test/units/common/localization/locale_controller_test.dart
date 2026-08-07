import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LocaleController', () {
    test('defaults to Russian', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(localeControllerProvider);
      expect(state.locale, const Locale('ru'));
      expect(state.isRussian, isTrue);
      expect(state.localeCodeLabel, 'RU');
      expect(state.isLoaded, isFalse);
      expect(LocaleController.supportedLocales, [const Locale('ru'), const Locale('en')]);
    });

    test('load and toggle persist locale', () async {
      SharedPreferences.setMockInitialValues({'app_locale': 'en'});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final c = container.read(localeControllerProvider.notifier);

      await c.load();
      var state = container.read(localeControllerProvider);
      expect(state.locale, const Locale('en'));
      expect(state.isRussian, isFalse);
      expect(state.localeCodeLabel, 'EN');
      expect(state.isLoaded, isTrue);

      await c.toggle();
      state = container.read(localeControllerProvider);
      expect(state.locale, const Locale('ru'));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_locale'), 'ru');

      await c.setLocale(const Locale('ru')); // no-op
      expect(prefs.getString('app_locale'), 'ru');
    });
  });
}
