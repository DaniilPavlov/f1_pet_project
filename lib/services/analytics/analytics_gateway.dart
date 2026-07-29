import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Единая точка отправки аналитических событий.
///
/// Реализация [AnalyticsGateway] фаннутит каждое событие сразу в Firebase
/// Analytics и AppMetrica. Логируется только в debug-режиме — в release SDKs
/// уже сами обеспечивают персистентность и батчинг.
abstract interface class AnalyticsGateway {
  /// Отправить событие во все подключённые системы.
  void log(AnalyticsEvent event);
}

/// Production-реализация: Firebase Analytics + AppMetrica.
///
/// Оба вызова — fire-and-forget (unawaited). Analytics — не критический путь;
/// ошибки не должны ломать UI.
final class AppAnalyticsGateway implements AnalyticsGateway {
  const AppAnalyticsGateway();

  @override
  void log(AnalyticsEvent event) {
    _logToFirebase(event);
    _logToAppMetrica(event);

    if (kDebugMode) {
      logger.d('[Analytics] ${event.name} ${event.params.isEmpty ? '' : event.params}');
    }
  }

  void _logToFirebase(AnalyticsEvent event) {
    // В debug-режиме коллекция отключена в firebase_bootstrap.dart,
    // но logEvent всё равно вызываем — Firebase DebugView их покажет.
    final analytics = FirebaseAnalytics.instance;

    if (event is ScreenView) {
      analytics
          .logScreenView(
            screenName: event.screenName,
            screenClass: event.screenClass,
          )
          .ignore();
      return;
    }

    analytics
        .logEvent(
          name: event.name,
          parameters: event.params.isEmpty ? null : event.params,
        )
        .ignore();
  }

  void _logToAppMetrica(AnalyticsEvent event) {
    if (kIsWeb) return;

    AppMetrica.reportEventWithMap(
      event.name,
      event.params.isEmpty ? null : Map<String, Object>.from(event.params),
    ).ignore();
  }
}

/// No-op реализация для тестов и случаев когда SDKs не инициализированы.
final class NoOpAnalyticsGateway implements AnalyticsGateway {
  const NoOpAnalyticsGateway();

  @override
  void log(AnalyticsEvent event) {}
}
