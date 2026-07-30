import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EspnScoreboardEvent', () {
    test('isLive when event or session is in', () {
      expect(
        const EspnScoreboardEvent(
          name: 'A',
          shortName: 'A',
          statusState: 'pre',
          statusDetail: '',
          sessions: [EspnScoreboardSession(abbreviation: 'Q', statusState: 'in', statusDetail: 'Live')],
        ).isLive,
        isTrue,
      );
      expect(
        const EspnScoreboardEvent(
          name: 'A',
          shortName: 'A',
          statusState: 'post',
          statusDetail: '',
          sessions: [],
        ).isLive,
        isFalse,
      );
    });

    test('highlightedSession prefers live then upcoming then last', () {
      const live = EspnScoreboardSession(abbreviation: 'Race', statusState: 'in', statusDetail: 'Live');
      const upcoming = EspnScoreboardSession(abbreviation: 'Q', statusState: 'pre', statusDetail: 'Soon');
      const done = EspnScoreboardSession(abbreviation: 'FP1', statusState: 'post', statusDetail: 'Final');

      expect(
        const EspnScoreboardEvent(
          name: 'A',
          shortName: 'A',
          statusState: 'in',
          statusDetail: '',
          sessions: [done, live, upcoming],
        ).highlightedSession,
        live,
      );
      expect(
        const EspnScoreboardEvent(
          name: 'A',
          shortName: 'A',
          statusState: 'pre',
          statusDetail: '',
          sessions: [done, upcoming],
        ).highlightedSession,
        upcoming,
      );
      expect(
        const EspnScoreboardEvent(
          name: 'A',
          shortName: 'A',
          statusState: 'post',
          statusDetail: '',
          sessions: [done],
        ).highlightedSession,
        done,
      );
      expect(
        const EspnScoreboardEvent(
          name: 'A',
          shortName: 'A',
          statusState: 'post',
          statusDetail: '',
          sessions: [],
        ).highlightedSession,
        isNull,
      );
    });
  });

  group('EspnScoreboardSession', () {
    test('status helpers', () {
      const session = EspnScoreboardSession(
        abbreviation: 'Race',
        statusState: 'pre',
        statusDetail: '',
        results: [EspnScoreboardResultEntry(position: 1, displayName: 'Max')],
      );
      expect(session.isUpcoming, isTrue);
      expect(session.isFinal, isFalse);
      expect(session.hasResults, isTrue);
    });
  });

  group('looksLikeEspnScheduleClock', () {
    test('detects ESPN EDT shortDetail and ignores status labels', () {
      expect(looksLikeEspnScheduleClock('8/21 - 6:30 AM EDT'), isTrue);
      expect(looksLikeEspnScheduleClock('Final'), isFalse);
      expect(looksLikeEspnScheduleClock('Scheduled'), isFalse);
      expect(looksLikeEspnScheduleClock('In Progress'), isFalse);
    });
  });
}
