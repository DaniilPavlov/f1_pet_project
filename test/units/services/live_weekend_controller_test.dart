import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

EspnScoreboardEvent _event({required String statusState, List<EspnScoreboardSession> sessions = const []}) {
  return EspnScoreboardEvent(
    name: 'Monaco Grand Prix',
    shortName: 'MON',
    statusState: statusState,
    statusDetail: statusState == 'in' ? 'Live' : 'Final',
    sessions: sessions,
    circuitName: 'Circuit de Monaco',
  );
}

EspnScoreboardSession _session({required String statusState, String abbr = 'Race'}) {
  return EspnScoreboardSession(
    abbreviation: abbr,
    statusState: statusState,
    statusDetail: statusState == 'in' ? 'Live' : 'Final',
  );
}

void main() {
  group('LiveWeekendController', () {
    test('sets scoreboard value and starts polling when live', () {
      fakeAsync((async) {
        var loads = 0;
        final controller = LiveWeekendController(
          fetchScoreboardForTest: ({bool forceRefresh = false}) async {
            loads++;
            return _event(
              statusState: 'in',
              sessions: [_session(statusState: 'in')],
            );
          },
          pollIntervalForTest: const Duration(seconds: 1),
        );

        var done = false;
        controller.loadScoreboard().then((_) => done = true);
        async.flushMicrotasks();
        expect(done, isTrue);

        expect(controller.scoreboard.isValue, isTrue);
        expect(controller.isLive, isTrue);
        expect(controller.liveSessionAbbreviation, 'Race');
        expect(controller.isPollingForTest, isTrue);
        expect(loads, 1);

        async
          ..elapse(const Duration(seconds: 1))
          ..flushMicrotasks();
        expect(loads, 2);

        controller.dispose();
        expect(controller.isPollingForTest, isFalse);
      });
    });

    test('does not poll when not live', () {
      fakeAsync((async) {
        final controller = LiveWeekendController(
          fetchScoreboardForTest: ({bool forceRefresh = false}) async => _event(statusState: 'post'),
          pollIntervalForTest: const Duration(seconds: 1),
        );

        var done = false;
        controller.loadScoreboard().then((_) => done = true);
        async.flushMicrotasks();
        expect(done, isTrue);

        expect(controller.isLive, isFalse);
        expect(controller.isPollingForTest, isFalse);
        controller.dispose();
      });
    });

    test('stops polling on background and resumes on foreground when live', () {
      fakeAsync((async) {
        final controller = LiveWeekendController(
          fetchScoreboardForTest: ({bool forceRefresh = false}) async => _event(
            statusState: 'in',
            sessions: [_session(statusState: 'in', abbr: 'Q')],
          ),
          pollIntervalForTest: const Duration(seconds: 1),
        );

        var done = false;
        controller.loadScoreboard().then((_) => done = true);
        async.flushMicrotasks();
        expect(done, isTrue);
        expect(controller.isPollingForTest, isTrue);

        controller.onAppLifecycleChanged(AppLifecycleState.paused);
        expect(controller.isPollingForTest, isFalse);

        controller.onAppLifecycleChanged(AppLifecycleState.resumed);
        async.flushMicrotasks();
        expect(controller.isPollingForTest, isTrue);

        controller.dispose();
      });
    });

    test('does not start a second timer while already polling', () {
      fakeAsync((async) {
        var loads = 0;
        final controller = LiveWeekendController(
          fetchScoreboardForTest: ({bool forceRefresh = false}) async {
            loads++;
            return _event(
              statusState: 'in',
              sessions: [_session(statusState: 'in')],
            );
          },
          pollIntervalForTest: const Duration(seconds: 2),
        );

        var firstDone = false;
        controller.loadScoreboard().then((_) => firstDone = true);
        async.flushMicrotasks();
        expect(firstDone, isTrue);

        var secondDone = false;
        controller.loadScoreboard(forceRefresh: true).then((_) => secondDone = true);
        async.flushMicrotasks();
        expect(secondDone, isTrue);

        expect(controller.isPollingForTest, isTrue);
        final loadsBeforeTick = loads;
        async
          ..elapse(const Duration(seconds: 2))
          ..flushMicrotasks();
        expect(loads, loadsBeforeTick + 1);

        controller.dispose();
      });
    });

    test('keeps null scoreboard usable when fetch fails', () async {
      final controller = LiveWeekendController(
        fetchScoreboardForTest: ({bool forceRefresh = false}) async => throw Exception('network'),
      );

      await controller.loadScoreboard();

      expect(controller.scoreboard.isValue, isTrue);
      expect(controller.scoreboard.value, isNull);
      expect(controller.isPollingForTest, isFalse);
      controller.dispose();
    });
  });
}
