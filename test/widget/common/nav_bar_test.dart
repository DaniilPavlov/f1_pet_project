import 'package:f1_pet_project/common/widgets/nav_bar/nav_bar_item.dart';
import 'package:f1_pet_project/common/widgets/nav_bar/navbar.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/recording_analytics_gateway.dart';

void main() {
  group('NavBarItem', () {
    testWidgets('renders title and reacts to tap', (tester) async {
      var taps = 0;

      await tester.pumpApp(
        NavBarItem(imageAsset: 'assets/nav_bar/home.png', title: 'Home', isSelected: true, onPressed: () => taps++),
      );

      expect(find.text('Home'), findsOneWidget);
      await tester.tap(find.text('Home'));
      await tester.pump();
      expect(taps, 1);
    });
  });

  group('NavBar', () {
    testWidgets('renders tabs and logs analytics for each switch', (tester) async {
      final gateway = RecordingAnalyticsGateway();
      final l10n = AppLocalizationsEn();

      await tester.pumpApp(
        Provider<AnalyticsGateway>.value(value: gateway, child: const NavBar()),
        wrapInScaffold: true,
      );

      expect(find.text(l10n.navHome), findsOneWidget);
      expect(find.text(l10n.navResults), findsOneWidget);
      expect(find.text(l10n.navCalendar), findsOneWidget);
      expect(find.text(l10n.navNews), findsOneWidget);
      expect(find.text(l10n.navCircuits), findsOneWidget);

      for (final label in [l10n.navHome, l10n.navResults, l10n.navCalendar, l10n.navNews, l10n.navCircuits]) {
        await tester.tap(find.text(label));
        await tester.pump();
      }

      expect(gateway.events.whereType<TabSwitched>().map((e) => e.tab).toList(), [
        'home',
        'results',
        'schedule',
        'news',
        'circuits',
      ]);
    });
  });
}
