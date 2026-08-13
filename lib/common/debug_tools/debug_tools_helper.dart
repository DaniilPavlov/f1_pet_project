import 'package:flutter/foundation.dart';

/// Доступность debug overlay (inspector + talker).
///
/// По умолчанию включено вне release; на web выключено.
/// Принудительно: `--dart-define=isDebugToolsEnabled=true|false`.
abstract final class DebugToolsHelper {
  static bool get isEnabled {
    if (kIsWeb) {
      return false;
    }
    const configured = bool.hasEnvironment('isDebugToolsEnabled')
        ? bool.fromEnvironment('isDebugToolsEnabled')
        : null;
    return configured ?? !kReleaseMode;
  }
}
