/// Статус финиша сезона из Jolpica `/{year}/status`.
class FinishStatusItem {
  const FinishStatusItem({
    required this.statusId,
    required this.status,
    required this.count,
  });

  factory FinishStatusItem.fromJson(Map<String, dynamic> json) {
    final countRaw = json['count'];
    final count = countRaw is int ? countRaw : int.tryParse(countRaw?.toString() ?? '') ?? 0;
    return FinishStatusItem(
      statusId: json['statusId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      count: count,
    );
  }

  final String statusId;
  final String status;
  final int count;

  /// Retired / DNF-подобные и дисквалификации.
  bool get isHighlight {
    final lower = status.toLowerCase();
    return lower.contains('retir') ||
        lower.contains('disqual') ||
        lower.contains('accident') ||
        lower.contains('collision') ||
        lower.contains('did not start') ||
        lower.contains('dns') ||
        lower.contains('dnf') ||
        lower.startsWith('+') ||
        lower.contains('lapped') ||
        lower.contains('not classified');
  }
}
