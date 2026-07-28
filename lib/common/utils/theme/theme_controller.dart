import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_controller.g.dart';

/// Предпочтение темы: система / светлая / тёмная.
enum AppThemePreference {
  system,
  light,
  dark,
}

/// MobX-контроллер темы приложения (system по умолчанию).
class ThemeController = ThemeControllerBase with _$ThemeController;

/// Хранит и переключает [ThemeMode] приложения.
abstract class ThemeControllerBase with Store {
  static const _prefsKey = 'app_theme_preference';

  @observable
  AppThemePreference preference = AppThemePreference.system;

  @observable
  bool isLoaded = false;

  @computed
  ThemeMode get themeMode => switch (preference) {
        AppThemePreference.system => ThemeMode.system,
        AppThemePreference.light => ThemeMode.light,
        AppThemePreference.dark => ThemeMode.dark,
      };

  @computed
  IconData get preferenceIcon => switch (preference) {
        AppThemePreference.system => Icons.brightness_auto,
        AppThemePreference.light => Icons.light_mode,
        AppThemePreference.dark => Icons.dark_mode,
      };

  /// Загружает сохранённое предпочтение; без значения — system.
  @action
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    preference = switch (raw) {
      'light' => AppThemePreference.light,
      'dark' => AppThemePreference.dark,
      _ => AppThemePreference.system,
    };
    isLoaded = true;
  }

  /// Цикл: system → light → dark → system.
  @action
  Future<void> cycle() async {
    await setPreference(switch (preference) {
      AppThemePreference.system => AppThemePreference.light,
      AppThemePreference.light => AppThemePreference.dark,
      AppThemePreference.dark => AppThemePreference.system,
    });
  }

  @action
  Future<void> setPreference(AppThemePreference value) async {
    if (preference == value) {
      return;
    }
    preference = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      switch (value) {
        AppThemePreference.system => 'system',
        AppThemePreference.light => 'light',
        AppThemePreference.dark => 'dark',
      },
    );
  }
}
