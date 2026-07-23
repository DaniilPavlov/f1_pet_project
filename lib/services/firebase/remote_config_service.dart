import 'package:f1_pet_project/common/utils/helpers/app_version.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Обёртка над Firebase Remote Config.
class RemoteConfigService {
  RemoteConfigService();

  /// Разрешает создание локальных уведомлений (напоминания о сессиях).
  static const localNotificationsEnabledKey = 'local_notifications_enabled';

  /// Минимально допустимая версия приложения (semver). Ниже — экран обновления.
  static const minAppVersionKey = 'min_app_version';

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  bool get localNotificationsEnabled => _remoteConfig.getBool(localNotificationsEnabledKey);

  String get minAppVersion => _remoteConfig.getString(minAppVersionKey);

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 1),
      ),
    );
    await _remoteConfig.setDefaults(const {
      localNotificationsEnabledKey: true,
      minAppVersionKey: '0.0.0',
    });

    try {
      final activated = await _remoteConfig.fetchAndActivate();
      if (kDebugMode) {
        logger.d(
          'Remote Config activated=$activated, '
          '$localNotificationsEnabledKey=$localNotificationsEnabled, '
          '$minAppVersionKey=$minAppVersion',
        );
      }
    } on Object catch (error, stackTrace) {
      logger.w('Remote Config fetch failed, using defaults', error: error, stackTrace: stackTrace);
    }
  }

  /// Повторный fetch (например при resume приложения).
  Future<void> refresh() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } on Object catch (error, stackTrace) {
      logger.w('Remote Config refresh failed', error: error, stackTrace: stackTrace);
    }
  }

  /// `true`, если установленная версия ниже [minAppVersion].
  Future<bool> isUpdateRequired() async {
    final info = await PackageInfo.fromPlatform();
    final required = AppVersion.isLowerThan(info.version, minAppVersion);
    if (kDebugMode) {
      logger.d(
        'Version check: installed=${info.version}, min=$minAppVersion, updateRequired=$required',
      );
    }
    return required;
  }
}
