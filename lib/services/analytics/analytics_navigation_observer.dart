import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:flutter/widgets.dart';

/// AutoRoute-observer, который автоматически шлёт [ScreenView] при каждой
/// навигации. Подключается к [AppRouter.delegate] через `navigatorObservers`.
final class AnalyticsNavigationObserver extends AutoRouterObserver {
  AnalyticsNavigationObserver(this._gateway);

  final AnalyticsGateway _gateway;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _trackRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) _trackRoute(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Трекаем экран, на который возвращаемся — так воронка остаётся честной.
    if (previousRoute != null) _trackRoute(previousRoute);
  }

  void _trackRoute(Route<dynamic> route) {
    final name = _screenName(route);
    if (name == null) return;

    _gateway.log(ScreenView(screenName: name, screenClass: route.settings.name));
  }

  /// Нормализует имя маршрута в читаемое имя экрана.
  static String? _screenName(Route<dynamic> route) {
    final routeName = route.settings.name;
    if (routeName == null || routeName.isEmpty || routeName == '/') return null;

    return routeName
        .split('/')
        .where((s) => s.isNotEmpty)
        .join('_')
        .toLowerCase();
  }
}
