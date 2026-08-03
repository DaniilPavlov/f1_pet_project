/// Валидация и нормализация ника для лидерборда предиктора.
abstract final class PredictorNickname {
  static const minLength = 3;
  static const maxLength = 16;

  static final RegExp _allowed = RegExp(r'^[a-zA-Z0-9_]+$');

  /// Trim + lowercase для uniqueness-ключа в Firestore.
  static String normalize(String raw) => raw.trim().toLowerCase();

  /// `null` при валидном нике; иначе l10n-ключ ошибки.
  static String? validate(String raw) {
    final trimmed = raw.trim();
    if (trimmed.length < minLength || trimmed.length > maxLength) {
      return 'predictorNicknameErrorLength';
    }
    if (!_allowed.hasMatch(trimmed)) {
      return 'predictorNicknameErrorChars';
    }
    return null;
  }
}
