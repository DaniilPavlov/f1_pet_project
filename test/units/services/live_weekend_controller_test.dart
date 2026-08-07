import 'dart:async';

import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';

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
    (ProviderContainer, LiveWeekendController) create({
      Future<EspnScoreboardEvent?> Function({bool forceRefresh})? fetchScoreboardForTest,
      Duration? pollIntervalForTest,
      List<Override> extraOverrides = const [],
    }) {
      late LiveWeekendController controller;
      final container = ProviderContainer(
        overrides: [
          liveWeekendControllerProvider.overrideWith(
            () => controller = LiveWeekendController(
              fetchScoreboardForTest: fetchScoreboardForTest,
              pollIntervalForTest: pollIntervalForTest,
            ),
          ),
          ...extraOverrides,
        ],
      );
      addTearDown(container.dispose);
      controller = container.read(liveWeekendControllerProvider.notifier);
      return (container, controller);
    }

    LiveWeekendState stateOf(ProviderContainer container) => container.read(liveWeekendControllerProvider);

    test('sets scoreboard value and starts polling when live', () {
      fakeAsync((async) {
        var loads = 0;
        final (container, controller) = create(
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

        final state = stateOf(container);
        expect(state.scoreboard.isValue, isTrue);
        expect(state.isLive, isTrue);
        expect(state.liveSessionAbbreviation, 'Race');
        expect(controller.isPollingForTest, isTrue);
        expect(loads, 1);

        async
          ..elapse(const Duration(seconds: 1))
          ..flushMicrotasks();
        expect(loads, 2);
      });
    });

    test('does not poll when not live', () {
      fakeAsync((async) {
        final (container, controller) = create(
          fetchScoreboardForTest: ({bool forceRefresh = false}) async => _event(statusState: 'post'),
          pollIntervalForTest: const Duration(seconds: 1),
        );

        var done = false;
        controller.loadScoreboard().then((_) => done = true);
        async.flushMicrotasks();
        expect(done, isTrue);

        expect(stateOf(container).isLive, isFalse);
        expect(controller.isPollingForTest, isFalse);
      });
    });

    test('stops polling on background and resumes on foreground when live', () {
      fakeAsync((async) {
        final (_, controller) = create(
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
      });
    });

    test('does not start a second timer while already polling', () {
      fakeAsync((async) {
        var loads = 0;
        final (_, controller) = create(
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
      });
    });

    test('keeps null scoreboard usable when fetch fails', () async {
      final (container, controller) = create(
        fetchScoreboardForTest: ({bool forceRefresh = false}) async => throw Exception('network'),
      );

      await controller.loadScoreboard();

      final state = stateOf(container);
      expect(state.scoreboard.isValue, isTrue);
      expect(state.scoreboard.value, isNull);
      expect(controller.isPollingForTest, isFalse);
    });

    test('uses shared scoreboard repository cache when fresh', () async {
      final event = _event(statusState: 'post');
      final repo = FakeEspnScoreboardRepository(cached: event, fresh: true);
      final (container, controller) = create(
        extraOverrides: [espnScoreboardRepositoryProvider.overrideWithValue(repo)],
      );

      await controller.loadScoreboard();

      expect(stateOf(container).scoreboard.value, event);
      expect(repo.loadCalls, 0);
    });

    test('shows stale cache then refreshes via repository', () async {
      final stale = _event(statusState: 'post');
      final fresh = _event(
        statusState: 'in',
        sessions: [_session(statusState: 'in')],
      );
      final repo = FakeEspnScoreboardRepository(cached: stale, fresh: false, next: fresh);
      final (container, controller) = create(
        pollIntervalForTest: const Duration(days: 1),
        extraOverrides: [espnScoreboardRepositoryProvider.overrideWithValue(repo)],
      );

      await controller.loadScoreboard();

      expect(stateOf(container).scoreboard.value, fresh);
      expect(repo.loadCalls, 1);
    });

    test('poll tick stops when no longer live', () {
      fakeAsync((async) {
        var loads = 0;
        final (container, controller) = create(
          fetchScoreboardForTest: ({bool forceRefresh = false}) async {
            loads++;
            if (loads == 1) {
              return _event(
                statusState: 'in',
                sessions: [_session(statusState: 'in')],
              );
            }
            return _event(statusState: 'post');
          },
          pollIntervalForTest: const Duration(seconds: 1),
        );
        unawaited(controller.loadScoreboard());
        async.flushMicrotasks();
        expect(controller.isPollingForTest, isTrue);

        async
          ..elapse(const Duration(seconds: 1))
          ..flushMicrotasks();
        expect(stateOf(container).isLive, isFalse);
        expect(controller.isPollingForTest, isFalse);
      });
    });

    test('detached lifecycle stops polling', () {
      fakeAsync((async) {
        final (_, controller) = create(
          fetchScoreboardForTest: ({bool forceRefresh = false}) async => _event(
            statusState: 'in',
            sessions: [_session(statusState: 'in')],
          ),
          pollIntervalForTest: const Duration(seconds: 1),
        );
        unawaited(controller.loadScoreboard());
        async.flushMicrotasks();
        expect(controller.isPollingForTest, isTrue);

        controller.onAppLifecycleChanged(AppLifecycleState.detached);
        expect(controller.isPollingForTest, isFalse);
      });
    });
  });
}
