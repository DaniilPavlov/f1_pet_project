import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/firebase_options.dart';
import 'package:f1_pet_project/services/firebase/crashlytics_reporting.dart';
import 'package:f1_pet_project/services/firebase/remote_config_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Инициализация Firebase + App Check + Analytics + Crashlytics + Remote Config.
Future<RemoteConfigService> bootstrapFirebase() async {
  await _ensureFirebaseApp();
  await _activateAppCheck();

  // Crashlytics не поддерживает web — иначе bootstrap падает до runApp (белый экран).
  if (!kIsWeb) {
    FlutterError.onError = (details) {
      if (shouldReportUncaughtErrorToCrashlytics(details.exception)) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      }
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      if (shouldReportUncaughtErrorToCrashlytics(error)) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
      return true;
    };
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);

  final remoteConfig = RemoteConfigService();
  await remoteConfig.init();

  if (kDebugMode) {
    logger.d('Firebase initialized (${DefaultFirebaseOptions.currentPlatform.projectId})');
  }

  return remoteConfig;
}

/// `google-services` / native SDK часто уже создают `[DEFAULT]`, а Dart-side
/// `Firebase.apps` ещё пустой — тогда `initializeApp` кидает `duplicate-app`.
Future<void> _ensureFirebaseApp() async {
  if (Firebase.apps.isNotEmpty) {
    return;
  }
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } on FirebaseException catch (error) {
    if (error.code == 'duplicate-app') {
      return;
    }
    rethrow;
  } on PlatformException catch (error) {
    if (error.code == 'duplicate-app' || (error.message?.contains('duplicate-app') ?? false)) {
      return;
    }
    rethrow;
  }
}

Future<void> _activateAppCheck() async {
  try {
    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode ? const AndroidDebugProvider() : const AndroidPlayIntegrityProvider(),
      providerApple: kDebugMode ? const AppleDebugProvider() : const AppleAppAttestProvider(),
    );
  } on Object catch (error, stackTrace) {
    logger.e('Firebase App Check activate failed', error: error, stackTrace: stackTrace);
  }
}
