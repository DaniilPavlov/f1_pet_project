extension StringExtensions on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String truncateWithEllipsis(int cutoff) {
    return (length <= cutoff) ? this : '${substring(0, cutoff)}.';
  }
}
