/// Маппинг национальностей / стран Jolpica → ISO 3166-1 alpha-2.
abstract class CountryFlagCodes {
  /// Возвращает ISO-код или `null`, если неизвестно.
  static String? resolve(String? raw) {
    if (raw == null) {
      return null;
    }
    final key = raw.trim().toLowerCase();
    if (key.isEmpty) {
      return null;
    }
    return _codes[key];
  }

  /// Эмодзи-флаг из ISO-кода (например `gb` → 🇬🇧).
  static String toEmoji(String isoCode) {
    final upper = isoCode.toUpperCase();
    if (upper.length != 2) {
      return '';
    }
    const base = 0x1F1E6;
    return String.fromCharCodes([
      base + upper.codeUnitAt(0) - 0x41,
      base + upper.codeUnitAt(1) - 0x41,
    ]);
  }

  static const _codes = <String, String>{
    // Nationalities (Ergast / Jolpica)
    'american': 'us',
    'argentine': 'ar',
    'australian': 'au',
    'austrian': 'at',
    'azerbaijani': 'az',
    'bahraini': 'bh',
    'belgian': 'be',
    'brazilian': 'br',
    'british': 'gb',
    'canadian': 'ca',
    'chinese': 'cn',
    'colombian': 'co',
    'czech': 'cz',
    'danish': 'dk',
    'dutch': 'nl',
    'east german': 'de',
    'emirati': 'ae',
    'finnish': 'fi',
    'french': 'fr',
    'german': 'de',
    'hungarian': 'hu',
    'indian': 'in',
    'indonesian': 'id',
    'irish': 'ie',
    'italian': 'it',
    'japanese': 'jp',
    'korean': 'kr',
    'liechtensteiner': 'li',
    'malaysian': 'my',
    'mexican': 'mx',
    'monegasque': 'mc',
    'moroccan': 'ma',
    'new zealander': 'nz',
    'polish': 'pl',
    'portuguese': 'pt',
    'qatari': 'qa',
    'rhodesian': 'zw',
    'russian': 'ru',
    'saudi': 'sa',
    'singaporean': 'sg',
    'south african': 'za',
    'spanish': 'es',
    'swedish': 'se',
    'swiss': 'ch',
    'thai': 'th',
    'turkish': 'tr',
    'uruguayan': 'uy',
    'venezuelan': 've',
    // Countries (circuits / locations)
    'argentina': 'ar',
    'australia': 'au',
    'austria': 'at',
    'azerbaijan': 'az',
    'bahrain': 'bh',
    'belgium': 'be',
    'brazil': 'br',
    'britain': 'gb',
    'canada': 'ca',
    'china': 'cn',
    'england': 'gb',
    'finland': 'fi',
    'france': 'fr',
    'germany': 'de',
    'great britain': 'gb',
    'hungary': 'hu',
    'india': 'in',
    'italy': 'it',
    'japan': 'jp',
    'korea': 'kr',
    'malaysia': 'my',
    'mexico': 'mx',
    'monaco': 'mc',
    'morocco': 'ma',
    'netherlands': 'nl',
    'new zealand': 'nz',
    'portugal': 'pt',
    'qatar': 'qa',
    'russia': 'ru',
    'saudi arabia': 'sa',
    'singapore': 'sg',
    'south africa': 'za',
    'spain': 'es',
    'sweden': 'se',
    'switzerland': 'ch',
    'thailand': 'th',
    'turkey': 'tr',
    'uae': 'ae',
    'united arab emirates': 'ae',
    'uk': 'gb',
    'united kingdom': 'gb',
    'usa': 'us',
    'united states': 'us',
  };
}
