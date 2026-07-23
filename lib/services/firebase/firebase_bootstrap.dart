import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/firebase_options.dart';
import 'package:f1_pet_project/services/firebase/remote_config_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Инициализация Firebase + Analytics + Crashlytics + Remote Config.
Future<RemoteConfigService> bootstrapFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);

  final remoteConfig = RemoteConfigService();
  await remoteConfig.init();

  if (kDebugMode) {
    logger.d('Firebase initialized (${DefaultFirebaseOptions.currentPlatform.projectId})');
  }

  return remoteConfig;
}
