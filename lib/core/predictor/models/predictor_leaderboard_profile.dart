/// Профиль участия в лидерборде предиктора (`users/{uid}`).
class PredictorLeaderboardProfile {
  const PredictorLeaderboardProfile({
    this.nickname,
    this.leaderboardOptIn = false,
  });

  factory PredictorLeaderboardProfile.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PredictorLeaderboardProfile();
    }
    final nickname = json['nickname'];
    return PredictorLeaderboardProfile(
      nickname: nickname is String && nickname.trim().isNotEmpty ? nickname.trim() : null,
      leaderboardOptIn: json['leaderboardOptIn'] == true,
    );
  }

  final String? nickname;
  final bool leaderboardOptIn;

  bool get canShowOnLeaderboard =>
      leaderboardOptIn && nickname != null && nickname!.trim().isNotEmpty;

  PredictorLeaderboardProfile copyWith({
    String? nickname,
    bool? leaderboardOptIn,
  }) {
    return PredictorLeaderboardProfile(
      nickname: nickname ?? this.nickname,
      leaderboardOptIn: leaderboardOptIn ?? this.leaderboardOptIn,
    );
  }
}
