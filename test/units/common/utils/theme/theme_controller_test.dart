import 'package:f1_pet_project/common/utils/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ThemeController', () {
    test('defaults to system until load', () {
      final controller = ThemeController();
      expect(controller.preference, AppThemePreference.system);
      expect(controller.themeMode, ThemeMode.system);
      expect(controller.preferenceIcon, Icons.brightness_auto);
      expect(controller.isLoaded, isFalse);
    });

    test('load reads prefs and setPreference persists', () async {
      SharedPreferences.setMockInitialValues({'app_theme_preference': 'dark'});
      final controller = ThemeController();

      await controller.load();
      expect(controller.preference, AppThemePreference.dark);
      expect(controller.themeMode, ThemeMode.dark);
      expect(controller.preferenceIcon, Icons.dark_mode);
      expect(controller.isLoaded, isTrue);

      await controller.setPreference(AppThemePreference.light);
      expect(controller.themeMode, ThemeMode.light);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_theme_preference'), 'light');

      // no-op when same
      await controller.setPreference(AppThemePreference.light);
      expect(prefs.getString('app_theme_preference'), 'light');
    });

    test('cycle rotates system → light → dark → system', () async {
      final controller = ThemeController();
      await controller.load();

      await controller.cycle();
      expect(controller.preference, AppThemePreference.light);

      await controller.cycle();
      expect(controller.preference, AppThemePreference.dark);

      await controller.cycle();
      expect(controller.preference, AppThemePreference.system);
    });
  });
}
