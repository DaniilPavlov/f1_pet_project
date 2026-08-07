import 'package:f1_pet_project/common/utils/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ThemeController', () {
    test('defaults to system until load', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(themeControllerProvider);
      expect(state.preference, AppThemePreference.system);
      expect(state.themeMode, ThemeMode.system);
      expect(state.preferenceIcon, Icons.brightness_auto);
      expect(state.isLoaded, isFalse);
    });

    test('load reads prefs and setPreference persists', () async {
      SharedPreferences.setMockInitialValues({'app_theme_preference': 'dark'});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final c = container.read(themeControllerProvider.notifier);

      await c.load();
      var state = container.read(themeControllerProvider);
      expect(state.preference, AppThemePreference.dark);
      expect(state.themeMode, ThemeMode.dark);
      expect(state.preferenceIcon, Icons.dark_mode);
      expect(state.isLoaded, isTrue);

      await c.setPreference(AppThemePreference.light);
      state = container.read(themeControllerProvider);
      expect(state.themeMode, ThemeMode.light);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_theme_preference'), 'light');

      // no-op when same
      await c.setPreference(AppThemePreference.light);
      expect(prefs.getString('app_theme_preference'), 'light');
    });

    test('cycle rotates system → light → dark → system', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final c = container.read(themeControllerProvider.notifier);
      await c.load();

      await c.cycle();
      expect(container.read(themeControllerProvider).preference, AppThemePreference.light);

      await c.cycle();
      expect(container.read(themeControllerProvider).preference, AppThemePreference.dark);

      await c.cycle();
      expect(container.read(themeControllerProvider).preference, AppThemePreference.system);
    });
  });
}
