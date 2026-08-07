import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Состояние локали приложения.
@immutable
class LocaleState {
  const LocaleState({
    this.locale = const Locale('ru'),
    this.isLoaded = false,
  });

  final Locale locale;
  final bool isLoaded;

  bool get isRussian => locale.languageCode == 'ru';

  String get localeCodeLabel => isRussian ? 'RU' : 'EN';

  LocaleState copyWith({Locale? locale, bool? isLoaded}) {
    return LocaleState(
      locale: locale ?? this.locale,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

/// Хранит и переключает локаль приложения (ru по умолчанию).
class LocaleController extends Notifier<LocaleState> {
  static const _prefsKey = 'app_locale';
  static const supportedLocales = [Locale('ru'), Locale('en')];

  @override
  LocaleState build() => const LocaleState();

  /// Загружает сохранённую локаль; без значения — русский.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    state = state.copyWith(
      locale: code == 'en' ? const Locale('en') : const Locale('ru'),
      isLoaded: true,
    );
  }

  Future<void> toggle() async {
    await setLocale(state.isRussian ? const Locale('en') : const Locale('ru'));
  }

  Future<void> setLocale(Locale value) async {
    if (state.locale == value) return;
    state = state.copyWith(locale: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, value.languageCode);
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, LocaleState>(LocaleController.new);
