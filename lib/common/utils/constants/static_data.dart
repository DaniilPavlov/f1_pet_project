/// Статические константы приложения: отступы и URL API.
class StaticData {
  static const defaultHorizontalPadding = 12.0;
  static const defaultVerticalPadding = 20.0;

  /// Repository of this API: https://github.com/jolpica/jolpica-f1
  static const apiUrl = 'https://api.jolpi.ca/ergast/f1/';

  /// Неофициальный ESPN Site API (F1 news / scoreboard).
  /// Docs: https://github.com/pseudo-r/Public-ESPN-API/blob/main/docs/sports/racing.md
  /// Без `limit` отдаёт ~6 статей; максимум для endpoint — 50.
  static const espnF1NewsUrl = 'https://site.api.espn.com/apis/site/v2/sports/racing/f1/news';
  static const espnF1NewsLimit = 50;
  static const espnF1ScoreboardUrl = 'https://site.api.espn.com/apis/site/v2/sports/racing/f1/scoreboard';

  /// TTL in-memory кэша ESPN (повторное открытие экранов в рамках сессии).
  static const espnScoreboardCacheTtl = Duration(minutes: 5);
  static const espnNewsCacheTtl = Duration(minutes: 15);

  /// Интервал live-обновления scoreboard, пока сессия `in`.
  static const espnScoreboardPollInterval = Duration(seconds: 30);

  /// Поиск ESPN (пилоты F1 → id).
  static const espnSearchUrl = 'https://site.web.api.espn.com/apis/common/v3/search';

  /// Карточка атлета F1 в core API (в т.ч. `headshot.href`, `flag`).
  static String espnF1AthleteUrl(String espnAthleteId) =>
      'https://sports.core.api.espn.com/v2/sports/racing/leagues/f1/athletes/$espnAthleteId';

  /// Overview атлета (новости и пр.).
  static String espnF1AthleteOverviewUrl(String espnAthleteId) =>
      'https://site.web.api.espn.com/apis/common/v3/sports/racing/f1/athletes/$espnAthleteId/overview';

  /// Крупное фото через ESPN combiner (исходник — headshot `full`).
  static String espnF1DriverPhotoUrl(String headshotPath) =>
      'https://a.espncdn.com/combiner/i?img=$headshotPath&w=1200&h=800';

  /// Wikipedia MediaWiki API (pageimages) — lead-изображение статьи.
  static const wikipediaUserAgent = 'F1PetProject/1.0 (https://github.com; Flutter app)';

  /// Релизы приложения на GitHub (кнопка обязательного обновления).
  static const githubReleasesUrl = 'https://github.com/DaniilPavlov/f1_pet_project/releases';
}
