/// Strategy: клиентские проверки email/password до вызова Firebase Auth.
///
/// Без сетевых запросов; disposable-список — мягкий фильтр, не полный блоклист.
abstract final class AuthFormValidators {
  static const minPasswordLength = 8;

  /// ≥8 символов, есть буква и цифра.
  static bool isPasswordStrongEnough(String password) {
    if (password.length < minPasswordLength) {
      return false;
    }
    final hasLetter = RegExp('[A-Za-zА-Яа-яЁё]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);
    return hasLetter && hasDigit;
  }

  /// Простой формат email (не RFC-полный).
  static bool isEmailFormatOk(String email) {
    final trimmed = email.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmed);
  }

  /// Домен после `@` (lowercase) или null.
  static String? emailDomain(String email) {
    final at = email.trim().lastIndexOf('@');
    if (at < 0 || at == email.trim().length - 1) {
      return null;
    }
    return email.trim().substring(at + 1).toLowerCase();
  }

  /// Известные disposable / temp-mail домены.
  ///
  /// Временные почтовые сервисы (mailinator, yopmail и т.п.): ящик создают
  /// на минуту и выбрасывают — удобно фармить аккаунты без реальной почты.
  /// Список короткий и клиентский, не исчерпывающий; при регистрации домен
  /// после `@` сверяется с ним (включая поддомены `*.mailinator.com`).
  static bool isDisposableEmail(String email) {
    final domain = emailDomain(email);
    if (domain == null || domain.isEmpty) {
      return false;
    }
    if (_disposableDomains.contains(domain)) {
      return true;
    }
    // Поддомены вида *.mailinator.com
    return _disposableDomains.any((blocked) => domain.endsWith('.$blocked'));
  }

  /// Чёрный список доменов временной почты (см. [isDisposableEmail]).
  static const _disposableDomains = <String>{
    '10minutemail.com',
    '1secmail.com',
    'discard.email',
    'dispostable.com',
    'fakeinbox.com',
    'getnada.com',
    'guerrillamail.com',
    'guerrillamail.de',
    'guerrillamail.net',
    'guerrillamail.org',
    'mailinator.com',
    'mailnesia.com',
    'maildrop.cc',
    'meltmail.com',
    'moakt.com',
    'sharklasers.com',
    'spam4.me',
    'temp-mail.org',
    'tempail.com',
    'tempmail.com',
    'tempmailo.com',
    'throwawaymail.com',
    'tmpmail.net',
    'tmpmail.org',
    'trashmail.com',
    'yopmail.com',
    'yopmail.fr',
  };
}
