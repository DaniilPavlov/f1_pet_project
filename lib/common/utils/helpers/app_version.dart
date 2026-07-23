/// Сравнение semver (major.minor.patch), без pre-release/build metadata.
class AppVersion {
  AppVersion._();

  /// `true`, если [current] строго меньше [minimum].
  static bool isLowerThan(String current, String minimum) {
    final a = _parts(current);
    final b = _parts(minimum);
    for (var i = 0; i < 3; i++) {
      if (a[i] < b[i]) {
        return true;
      }
      if (a[i] > b[i]) {
        return false;
      }
    }
    return false;
  }

  static List<int> _parts(String raw) {
    final core = raw.split('+').first.split('-').first;
    final chunks = core.split('.');
    return List<int>.generate(3, (i) {
      if (i >= chunks.length) {
        return 0;
      }
      return int.tryParse(chunks[i]) ?? 0;
    });
  }
}
