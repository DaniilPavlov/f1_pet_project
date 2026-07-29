/// Все аналитические события приложения.
///
/// Sealed-класс гарантирует exhaustive switch при добавлении новых событий.
/// Каждый subtype — конкретное действие пользователя или системное событие.
sealed class AnalyticsEvent {
  const AnalyticsEvent();

  /// Имя события для Firebase / AppMetrica (snake_case).
  String get name;

  /// Параметры события (только примитивы: String / int / double / bool).
  Map<String, Object> get params => const {};
}

// ─── Navigation ─────────────────────────────────────────────────────────────

/// Экран стал видимым.
final class ScreenView extends AnalyticsEvent {
  const ScreenView({required this.screenName, this.screenClass});

  final String screenName;
  final String? screenClass;

  @override
  String get name => 'screen_view';

  @override
  Map<String, Object> get params => {'screen_name': screenName, 'screen_class': ?screenClass};
}

/// Пользователь переключил вкладку нижней навигации.
final class TabSwitched extends AnalyticsEvent {
  const TabSwitched({required this.tab});

  /// Имя вкладки: home / results / schedule / news / circuits.
  final String tab;

  @override
  String get name => 'tab_switched';

  @override
  Map<String, Object> get params => {'tab': tab};
}

// ─── Race ────────────────────────────────────────────────────────────────────

/// Пользователь открыл детали гонки.
final class RaceOpened extends AnalyticsEvent {
  const RaceOpened({required this.raceName, required this.season, required this.round});

  final String raceName;
  final String season;
  final String round;

  @override
  String get name => 'race_opened';

  @override
  Map<String, Object> get params => {'race_name': raceName, 'season': season, 'round': round};
}

// ─── H2H ─────────────────────────────────────────────────────────────────────

/// Пользователь запустил сравнение двух пилотов.
final class H2hCompared extends AnalyticsEvent {
  const H2hCompared({required this.driverA, required this.driverB, required this.scopeMode, this.season});

  final String driverA;
  final String driverB;

  /// null — сравнение за карьеру.
  final String? season;

  /// 'career' | 'season'.
  final String scopeMode;

  @override
  String get name => 'h2h_compared';

  @override
  Map<String, Object> get params => {'driver_a': driverA, 'driver_b': driverB, 'scope': scopeMode, 'season': ?season};
}

/// Пользователь запустил сравнение двух конструкторов.
final class H2hConstructorsCompared extends AnalyticsEvent {
  const H2hConstructorsCompared({
    required this.constructorA,
    required this.constructorB,
    required this.scopeMode,
    this.season,
  });

  final String constructorA;
  final String constructorB;
  final String? season;
  final String scopeMode;

  @override
  String get name => 'h2h_constructors_compared';

  @override
  Map<String, Object> get params => {
    'constructor_a': constructorA,
    'constructor_b': constructorB,
    'scope': scopeMode,
    'season': ?season,
  };
}

// ─── Entity pages ─────────────────────────────────────────────────────────────

/// Пользователь открыл профиль пилота.
final class DriverOpened extends AnalyticsEvent {
  const DriverOpened({required this.driverId, required this.driverName});

  final String driverId;
  final String driverName;

  @override
  String get name => 'driver_opened';

  @override
  Map<String, Object> get params => {'driver_id': driverId, 'driver_name': driverName};
}

/// Пользователь открыл профиль конструктора.
final class ConstructorOpened extends AnalyticsEvent {
  const ConstructorOpened({required this.constructorId, required this.constructorName});

  final String constructorId;
  final String constructorName;

  @override
  String get name => 'constructor_opened';

  @override
  Map<String, Object> get params => {'constructor_id': constructorId, 'constructor_name': constructorName};
}

/// Пользователь открыл детали трассы.
final class CircuitOpened extends AnalyticsEvent {
  const CircuitOpened({required this.circuitId, required this.circuitName});

  final String circuitId;
  final String circuitName;

  @override
  String get name => 'circuit_opened';

  @override
  Map<String, Object> get params => {'circuit_id': circuitId, 'circuit_name': circuitName};
}

// ─── Content ──────────────────────────────────────────────────────────────────

/// Пользователь открыл новость.
final class NewsOpened extends AnalyticsEvent {
  const NewsOpened({required this.headline});

  final String headline;

  @override
  String get name => 'news_opened';

  @override
  Map<String, Object> get params => {'headline': headline};
}

/// Пользователь открыл Зал Славы.
final class HallOfFameOpened extends AnalyticsEvent {
  const HallOfFameOpened();

  @override
  String get name => 'hall_of_fame_opened';
}

/// Пользователь поделился карточкой (race results / career).
final class ShareTapped extends AnalyticsEvent {
  const ShareTapped({required this.contentType});

  /// 'race_results' | 'career_card'.
  final String contentType;

  @override
  String get name => 'share_tapped';

  @override
  Map<String, Object> get params => {'content_type': contentType};
}

// ─── Settings / Preferences ──────────────────────────────────────────────────

/// Пользователь сменил тему.
final class ThemeChanged extends AnalyticsEvent {
  const ThemeChanged({required this.theme});

  /// 'light' | 'dark' | 'system'.
  final String theme;

  @override
  String get name => 'theme_changed';

  @override
  Map<String, Object> get params => {'theme': theme};
}

/// Пользователь сменил язык.
final class LocaleChanged extends AnalyticsEvent {
  const LocaleChanged({required this.locale});

  final String locale;

  @override
  String get name => 'locale_changed';

  @override
  Map<String, Object> get params => {'locale': locale};
}

/// Пользователь включил / выключил напоминания о гонке.
final class RaceReminderToggled extends AnalyticsEvent {
  const RaceReminderToggled({required this.enabled});

  final bool enabled;

  @override
  String get name => 'race_reminder_toggled';

  @override
  Map<String, Object> get params => {'enabled': enabled};
}

// ─── Search ───────────────────────────────────────────────────────────────────

/// Пользователь выполнил поиск гонки.
final class RaceSearched extends AnalyticsEvent {
  const RaceSearched({required this.query});

  final String query;

  @override
  String get name => 'race_searched';

  @override
  Map<String, Object> get params => {'query': query};
}
