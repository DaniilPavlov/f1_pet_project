import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Предпочтение темы: система / светлая / тёмная.
enum AppThemePreference {
  system,
  light,
  dark,
}

/// Состояние темы приложения.
@immutable
class ThemeState {
  const ThemeState({
    this.preference = AppThemePreference.system,
    this.isLoaded = false,
  });

  final AppThemePreference preference;
  final bool isLoaded;

  ThemeMode get themeMode => switch (preference) {
    AppThemePreference.system => ThemeMode.system,
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
  };

  IconData get preferenceIcon => switch (preference) {
    AppThemePreference.system => Icons.brightness_auto,
    AppThemePreference.light => Icons.light_mode,
    AppThemePreference.dark => Icons.dark_mode,
  };

  ThemeState copyWith({AppThemePreference? preference, bool? isLoaded}) {
    return ThemeState(
      preference: preference ?? this.preference,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

/// Хранит и переключает [ThemeMode] приложения (system по умолчанию).
class ThemeController extends Notifier<ThemeState> {
  static const _prefsKey = 'app_theme_preference';

  @override
  ThemeState build() => const ThemeState();

  /// Загружает сохранённое предпочтение; без значения — system.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    state = state.copyWith(
      preference: switch (raw) {
        'light' => AppThemePreference.light,
        'dark' => AppThemePreference.dark,
        _ => AppThemePreference.system,
      },
      isLoaded: true,
    );
  }

  /// Цикл: system → light → dark → system.
  Future<void> cycle() async {
    await setPreference(switch (state.preference) {
      AppThemePreference.system => AppThemePreference.light,
      AppThemePreference.light => AppThemePreference.dark,
      AppThemePreference.dark => AppThemePreference.system,
    });
  }

  Future<void> setPreference(AppThemePreference value) async {
    if (state.preference == value) {
      return;
    }
    state = state.copyWith(preference: value);
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

final themeControllerProvider = NotifierProvider<ThemeController, ThemeState>(ThemeController.new);
