// ignore_for_file: cascade_invocations

import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/analytics/analytics_navigation_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/recording_analytics_gateway.dart';

void main() {
  group('NoOpAnalyticsGateway', () {
    test('log is a no-op', () {
      const NoOpAnalyticsGateway().log(const TabSwitched(tab: 'home'));
    });
  });

  group('AnalyticsNavigationObserver', () {
    test('didPush logs ScreenView for named routes', () {
      final gateway = RecordingAnalyticsGateway();
      final observer = AnalyticsNavigationObserver(gateway);
      observer.didPush(_FakeRoute(const RouteSettings(name: 'HomeRoute')), null);
      expect(gateway.events, hasLength(1));
      final event = gateway.events.single as ScreenView;
      expect(event.screenName, 'homeroute');
      expect(event.screenClass, 'HomeRoute');
    });

    test('ignores empty and root route names', () {
      final gateway = RecordingAnalyticsGateway();
      final observer = AnalyticsNavigationObserver(gateway);

      observer.didPush(_FakeRoute(const RouteSettings()), null);
      observer.didPush(_FakeRoute(const RouteSettings(name: '/')), null);
      observer.didReplace(newRoute: _FakeRoute(const RouteSettings(name: '/')));

      expect(gateway.events, isEmpty);
    });

    test('didPop tracks previous route', () {
      final gateway = RecordingAnalyticsGateway();
      final observer = AnalyticsNavigationObserver(gateway);

      observer.didPop(_FakeRoute(const RouteSettings(name: 'Child')), _FakeRoute(const RouteSettings(name: 'Parent')));

      expect((gateway.events.single as ScreenView).screenName, 'parent');
    });

    test('nested path segments become snake_case', () {
      final gateway = RecordingAnalyticsGateway();
      AnalyticsNavigationObserver(gateway).didPush(_FakeRoute(const RouteSettings(name: '/Results/RaceInfo')), null);

      expect((gateway.events.single as ScreenView).screenName, 'results_raceinfo');
    });
  });
}


class _FakeRoute extends Route<void> {
  _FakeRoute(RouteSettings settings) : super(settings: settings);

  @override
  Future<RoutePopDisposition> willPop() async => RoutePopDisposition.bubble;
}
