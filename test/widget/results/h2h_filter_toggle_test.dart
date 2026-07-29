import 'package:f1_pet_project/core/results/h2h/components/h2h_filter_toggle.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('H2hFilterToggle', () {
    testWidgets('renders label and options and reports taps', (tester) async {
      var selected = 0;

      await tester.pumpApp(
        H2hFilterToggle(
          label: 'Period',
          firstTitle: 'Career',
          secondTitle: 'Season',
          activeIndex: selected,
          onChanged: (index) => selected = index,
        ),
      );

      expect(find.text('Period'), findsOneWidget);
      expect(find.text('Career'), findsOneWidget);
      expect(find.text('Season'), findsOneWidget);

      await tester.tap(find.text('Season'));
      await tester.pump();
      expect(selected, 1);
    });
  });
}
