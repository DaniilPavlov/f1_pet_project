/// Проверка и нормализация внешних ссылок перед открытием в браузере.
abstract final class TrustedUrl {
  static const _allowedHostSuffixes = <String>[
    'wikipedia.org',
    'wikimedia.org',
    'espn.com',
    'espn.co.uk',
    'github.com',
    'formula1.com',
    'jolpi.ca',
    'ergast.com',
  ];

  /// Возвращает нормализованный https-URI или `null`, если ссылка не доверенная.
  static Uri? parse(String rawUrl) {
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null || uri.host.isEmpty) {
      return null;
    }

    final normalized = switch (uri.scheme) {
      'https' => uri,
      'http' => uri.replace(scheme: 'https'),
      _ => null,
    };
    if (normalized == null || !_isAllowedHost(normalized.host)) {
      return null;
    }

    return normalized;
  }

  /// Для загрузки изображений: http → https без проверки allowlist.
  static String preferHttps(String rawUrl) {
    final uri = Uri.tryParse(rawUrl.trim());
    if (uri == null || uri.scheme != 'http') {
      return rawUrl;
    }
    return uri.replace(scheme: 'https').toString();
  }

  static bool _isAllowedHost(String host) {
    final lower = host.toLowerCase();
    for (final suffix in _allowedHostSuffixes) {
      if (lower == suffix || lower.endsWith('.$suffix')) {
        return true;
      }
    }
    return false;
  }
}
