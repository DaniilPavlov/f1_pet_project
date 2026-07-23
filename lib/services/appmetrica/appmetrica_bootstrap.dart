import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:f1_pet_project/app_config.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:flutter/foundation.dart';

/// CI/release: `--dart-define=APPMETRICA_API_KEY=...` (GitHub Secret).
/// Local: value from `.env` via [AppConfig] (envied).
String get _appMetricaApiKey {
  const fromDefine = String.fromEnvironment('APPMETRICA_API_KEY');
  if (fromDefine.isNotEmpty) return fromDefine;
  return AppConfig.appMetricaApiKey;
}

/// Инициализация AppMetrica. После [AppMetrica.activate] SDK сам шлёт
/// установки, сессии и app open — отдельные custom events не обязательны.
///
/// Краши отдаём Firebase Crashlytics, поэтому reporting в AppMetrica выключен.
Future<void> bootstrapAppMetrica() async {
  if (kIsWeb) return;

  final apiKey = _appMetricaApiKey;
  if (apiKey.isEmpty) {
    if (kDebugMode) {
      logger.d('AppMetrica skipped (no APPMETRICA_API_KEY in dart-define or .env)');
    }
    return;
  }

  try {
    await AppMetrica.activate(
      AppMetricaConfig(
        apiKey,
        crashReporting: false,
        flutterCrashReporting: false,
        nativeCrashReporting: false,
        locationTracking: false,
        logs: kDebugMode,
      ),
    );

    if (kDebugMode) {
      logger.d('AppMetrica activated');
    }
  } catch (e, s) {
    logger.e('AppMetrica activate failed', error: e, stackTrace: s);
  }
}
