/// Уикенд F1 из ESPN scoreboard.
class EspnScoreboardEvent {
  const EspnScoreboardEvent({
    required this.name,
    required this.shortName,
    required this.statusState,
    required this.statusDetail,
    required this.sessions,
    this.startDate,
    this.endDate,
    this.circuitName,
    this.circuitCity,
    this.circuitCountry,
  });

  final String name;
  final String shortName;
  final String statusState;
  final String statusDetail;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? circuitName;
  final String? circuitCity;
  final String? circuitCountry;
  final List<EspnScoreboardSession> sessions;

  bool get isLive => statusState == 'in' || sessions.any((s) => s.isLive);

  /// Актуальная сессия: live → ближайшая upcoming → последняя завершённая.
  EspnScoreboardSession? get highlightedSession {
    for (final session in sessions) {
      if (session.isLive) {
        return session;
      }
    }
    for (final session in sessions) {
      if (session.isUpcoming) {
        return session;
      }
    }
    if (sessions.isEmpty) {
      return null;
    }
    return sessions.last;
  }
}

/// Сессия уикенда (FP / Qual / Race / Sprint).
class EspnScoreboardSession {
  const EspnScoreboardSession({
    required this.abbreviation,
    required this.statusState,
    required this.statusDetail,
    this.date,
    this.leaderName,
    this.isWinner = false,
    this.results = const [],
  });

  final String abbreviation;
  final String statusState;
  final String statusDetail;
  final DateTime? date;
  final String? leaderName;
  final bool isWinner;
  final List<EspnScoreboardResultEntry> results;

  bool get isLive => statusState == 'in';

  bool get isUpcoming => statusState == 'pre';

  bool get isFinal => statusState == 'post';

  bool get hasResults => results.isNotEmpty;
}

/// Строка протокола сессии (позиция + пилот).
class EspnScoreboardResultEntry {
  const EspnScoreboardResultEntry({
    required this.position,
    required this.displayName,
    this.country,
    this.isWinner = false,
  });

  final int position;
  final String displayName;
  final String? country;
  final bool isWinner;
}

/// ESPN schedule shortDetail вида `8/21 - 6:30 AM EDT`.
bool looksLikeEspnScheduleClock(String value) {
  return RegExp(
    r'(\b(EDT|EST|PDT|PST|CET|BST)\b)|(\b(AM|PM)\b)|(\d{1,2}/\d{1,2})',
    caseSensitive: false,
  ).hasMatch(value);
}
