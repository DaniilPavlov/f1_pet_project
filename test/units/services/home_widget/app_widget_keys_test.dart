import 'package:f1_pet_project/services/home_widget/app_widget_keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppWidgetKeys', () {
    test('driver indexes and providers are stable', () {
      expect(AppWidgetKeys.driverCode(1), 'standings_d1_code');
      expect(AppWidgetKeys.driverPoints(3), 'standings_d3_points');
      expect(AppWidgetKeys.nextGpProvider, 'NextGpWidgetProvider');
      expect(AppWidgetKeys.standingsProvider, 'StandingsWidgetProvider');
      expect(AppWidgetKeys.prefsName, isNotEmpty);
      expect(AppWidgetKeys.iosAppGroup, startsWith('group.'));
    });
  });
}
