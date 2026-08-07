import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/widgets/live_session_banner.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

LiveWeekendController Function() _liveOverride({
  required String statusState,
  List<EspnScoreboardSession> sessions = const [],
}) {
  return () => LiveWeekendController(
    pollIntervalForTest: const Duration(days: 1),
    fetchScoreboardForTest: ({bool forceRefresh = false}) async => EspnScoreboardEvent(
      name: 'Monaco',
      shortName: 'MON',
      statusState: statusState,
      statusDetail: statusState == 'in' ? 'Live' : 'Final',
      sessions: sessions,
    ),
  );
}

Future<void> _pumpBanner(
  WidgetTester tester, {
  required LiveWeekendController Function() liveWeekend,
  required VoidCallback onTap,
}) async {
  final container = ProviderContainer(
    overrides: [liveWeekendControllerProvider.overrideWith(liveWeekend)],
  );
  addTearDown(container.dispose);

  await container.read(liveWeekendControllerProvider.notifier).loadScoreboard();
  // Banner UI tests only need loaded state; stop poll timer before test ends.
  container.read(liveWeekendControllerProvider.notifier).stopLivePolling();

  await tester.pumpApp(
    UncontrolledProviderScope(
      container: container,
      child: LiveSessionBanner(onTap: onTap),
    ),
  );
}

void main() {
  group('LiveSessionBanner', () {
    testWidgets('hides when not live', (tester) async {
      await _pumpBanner(
        tester,
        liveWeekend: _liveOverride(statusState: 'post'),
        onTap: () {},
      );

      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('shows session label and invokes onTap when live', (tester) async {
      var taps = 0;
      await _pumpBanner(
        tester,
        liveWeekend: _liveOverride(
          statusState: 'in',
          sessions: const [EspnScoreboardSession(abbreviation: 'Race', statusState: 'in', statusDetail: 'Live')],
        ),
        onTap: () => taps++,
      );

      final l10n = AppLocalizationsEn();
      expect(find.text(l10n.liveSessionBannerWithSession('Race')), findsOneWidget);

      await tester.tap(find.byType(InkWell));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('falls back to generic label without abbreviation', (tester) async {
      await _pumpBanner(
        tester,
        liveWeekend: _liveOverride(statusState: 'in'),
        onTap: () {},
      );

      expect(find.text(AppLocalizationsEn().liveSessionBanner), findsOneWidget);
    });
  });
}
