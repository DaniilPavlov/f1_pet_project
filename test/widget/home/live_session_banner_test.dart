import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/widgets/live_session_banner.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../helpers/pump_app.dart';

LiveWeekendController _liveController({required String statusState, List<EspnScoreboardSession> sessions = const []}) {
  return LiveWeekendController(
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

void main() {
  group('LiveSessionBanner', () {
    testWidgets('hides when not live', (tester) async {
      final live = _liveController(statusState: 'post');
      await live.loadScoreboard();

      await tester.pumpApp(
        Provider.value(
          value: live,
          child: LiveSessionBanner(onTap: () {}),
        ),
      );

      expect(find.byType(InkWell), findsNothing);
      live.dispose();
    });

    testWidgets('shows session label and invokes onTap when live', (tester) async {
      var taps = 0;
      final live = _liveController(
        statusState: 'in',
        sessions: const [EspnScoreboardSession(abbreviation: 'Race', statusState: 'in', statusDetail: 'Live')],
      );
      await live.loadScoreboard();

      await tester.pumpApp(
        Provider.value(
          value: live,
          child: LiveSessionBanner(onTap: () => taps++),
        ),
      );

      final l10n = AppLocalizationsEn();
      expect(find.text(l10n.liveSessionBannerWithSession('Race')), findsOneWidget);

      await tester.tap(find.byType(InkWell));
      await tester.pump();
      expect(taps, 1);
      live.dispose();
    });

    testWidgets('falls back to generic label without abbreviation', (tester) async {
      final live = _liveController(statusState: 'in');
      await live.loadScoreboard();

      await tester.pumpApp(
        Provider.value(
          value: live,
          child: LiveSessionBanner(onTap: () {}),
        ),
      );

      expect(find.text(AppLocalizationsEn().liveSessionBanner), findsOneWidget);
      live.dispose();
    });
  });
}
