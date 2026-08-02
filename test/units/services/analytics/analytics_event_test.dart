import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnalyticsEvent', () {
    test('ScreenView omits null screenClass', () {
      const event = ScreenView(screenName: 'home');
      expect(event.name, 'screen_view');
      expect(event.params, {'screen_name': 'home'});
    });

    test('ScreenView includes screenClass when set', () {
      const event = ScreenView(screenName: 'home', screenClass: 'HomeScreen');
      expect(event.params, {'screen_name': 'home', 'screen_class': 'HomeScreen'});
    });

    test('TabSwitched', () {
      const event = TabSwitched(tab: 'results');
      expect(event.name, 'tab_switched');
      expect(event.params, {'tab': 'results'});
    });

    test('RaceOpened', () {
      const event = RaceOpened(raceName: 'Monaco', season: '2024', round: '8');
      expect(event.name, 'race_opened');
      expect(event.params, {'race_name': 'Monaco', 'season': '2024', 'round': '8'});
    });

    test('H2hCompared omits null season', () {
      const event = H2hCompared(driverA: 'VER', driverB: 'LEC', scopeMode: 'career');
      expect(event.name, 'h2h_compared');
      expect(event.params, {'driver_a': 'VER', 'driver_b': 'LEC', 'scope': 'career'});
    });

    test('H2hCompared includes season', () {
      const event = H2hCompared(
        driverA: 'VER',
        driverB: 'LEC',
        scopeMode: 'season',
        season: '2024',
      );
      expect(event.params['season'], '2024');
    });

    test('H2hConstructorsCompared', () {
      const event = H2hConstructorsCompared(
        constructorA: 'Red Bull',
        constructorB: 'Ferrari',
        scopeMode: 'career',
      );
      expect(event.name, 'h2h_constructors_compared');
      expect(event.params, {
        'constructor_a': 'Red Bull',
        'constructor_b': 'Ferrari',
        'scope': 'career',
      });
    });

    test('DriverOpened / ConstructorOpened / CircuitOpened', () {
      expect(
        const DriverOpened(driverId: 'max_verstappen', driverName: 'Max Verstappen').params,
        {'driver_id': 'max_verstappen', 'driver_name': 'Max Verstappen'},
      );
      expect(
        const ConstructorOpened(constructorId: 'ferrari', constructorName: 'Ferrari').params,
        {'constructor_id': 'ferrari', 'constructor_name': 'Ferrari'},
      );
      expect(
        const CircuitOpened(circuitId: 'monaco', circuitName: 'Monaco').params,
        {'circuit_id': 'monaco', 'circuit_name': 'Monaco'},
      );
    });

    test('H2hConstructorsCompared includes season when set', () {
      const event = H2hConstructorsCompared(
        constructorA: 'Red Bull',
        constructorB: 'Ferrari',
        scopeMode: 'season',
        season: '2024',
      );
      expect(event.params['season'], '2024');
    });

    test('content and settings events', () {
      expect(const NewsOpened(headline: 'Title').name, 'news_opened');
      expect(const NewsOpened(headline: 'Title').params, {'headline': 'Title'});
      expect(const HallOfFameOpened().name, 'hall_of_fame_opened');
      expect(const HallOfFameOpened().params, isEmpty);
      expect(const SeasonRewindOpened().name, 'season_rewind_opened');
      expect(const SeasonRewindOpened().params, isEmpty);
      expect(const ShareTapped(contentType: 'career_card').name, 'share_tapped');
      expect(const ShareTapped(contentType: 'career_card').params, {'content_type': 'career_card'});
      expect(const ThemeChanged(theme: 'dark').name, 'theme_changed');
      expect(const ThemeChanged(theme: 'dark').params, {'theme': 'dark'});
      expect(const LocaleChanged(locale: 'ru').name, 'locale_changed');
      expect(const LocaleChanged(locale: 'ru').params, {'locale': 'ru'});
      expect(const RaceReminderToggled(enabled: true).name, 'race_reminder_toggled');
      expect(const RaceReminderToggled(enabled: true).params, {'enabled': true});
      expect(const PracticeReminderToggled(enabled: false).name, 'practice_reminder_toggled');
      expect(const PracticeReminderToggled(enabled: false).params, {'enabled': false});
      expect(const RaceSearched(query: 'monaco').name, 'race_searched');
      expect(const RaceSearched(query: 'monaco').params, {'query': 'monaco'});
    });

    test('entity event names', () {
      expect(const RaceOpened(raceName: 'Monaco', season: '2024', round: '8').name, 'race_opened');
      expect(const DriverOpened(driverId: 'a', driverName: 'A').name, 'driver_opened');
      expect(const ConstructorOpened(constructorId: 'c', constructorName: 'C').name, 'constructor_opened');
      expect(const CircuitOpened(circuitId: 'm', circuitName: 'M').name, 'circuit_opened');
    });
  });
}
