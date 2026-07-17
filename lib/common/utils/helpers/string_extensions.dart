/// Расширение [String] с утилитами форматирования текста.
extension StringExtensions on String {
  /// Делает первую букву заглавной, остальные — строчными.
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Обрезает строку до [cutoff] символов с точкой в конце.
  String truncateWithEllipsis(int cutoff) {
    return (length <= cutoff) ? this : '${substring(0, cutoff)}.';
  }
}
