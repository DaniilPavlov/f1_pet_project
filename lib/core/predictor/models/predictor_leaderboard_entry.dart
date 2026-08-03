/// Публичная запись лидерборда за сезон (`leaderboards/{year}/entries/{uid}`).
class PredictorLeaderboardEntry {
  const PredictorLeaderboardEntry({
    required this.uid,
    required this.nickname,
    required this.totalPoints,
    this.rank,
  });

  factory PredictorLeaderboardEntry.fromJson(String uid, Map<String, dynamic> json) {
    final nickname = json['nickname'];
    final points = json['totalPoints'];
    return PredictorLeaderboardEntry(
      uid: uid,
      nickname: nickname is String ? nickname : '—',
      totalPoints: points is int ? points : (points is num ? points.toInt() : 0),
    );
  }

  final String uid;
  final String nickname;
  final int totalPoints;

  /// 1-based место после сортировки; `null`, пока список не проранжирован.
  final int? rank;

  PredictorLeaderboardEntry withRank(int rank) => PredictorLeaderboardEntry(
    uid: uid,
    nickname: nickname,
    totalPoints: totalPoints,
    rank: rank,
  );

  Map<String, dynamic> toJson() => {
    'nickname': nickname,
    'totalPoints': totalPoints,
  };
}
