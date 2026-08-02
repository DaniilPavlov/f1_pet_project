import 'package:f1_pet_project/common/utils/constants/assets.dart';
import 'package:f1_pet_project/common/widgets/custom_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('CustomCalendar', () {
    testWidgets('renders and reports day selection', (tester) async {
      final now = DateTime.now();
      final selectedDay = DateTime(now.year, now.month, 15);
      DateTime? selected;
      DateTime? focused;

      await tester.pumpApp(
        CustomCalendar(
          selectedDay: selectedDay,
          focusedDay: selectedDay,
          onPageChanged: (_) {},
          onDaySelected: (day, focus) {
            selected = day;
            focused = focus;
          },
          imagePathCallback: (day) {
            if (isSameDay(day, selectedDay)) {
              return Assets.calendar.finish;
            }
            if (day.day == 10) {
              return Assets.calendar.car;
            }
            if (day.day == 5) {
              return '';
            }
            return null;
          },
        ),
        surfaceSize: const Size(390, 500),
      );

      expect(find.byType(TableCalendar<dynamic>), findsOneWidget);
      expect(find.byType(ChevronButton), findsNWidgets(2));

      await tester.tap(find.text('20'));
      await tester.pump();
      expect(selected?.day, 20);
      expect(focused, isNotNull);
    });
  });
}
