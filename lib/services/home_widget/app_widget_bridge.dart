import 'package:f1_pet_project/common/utils/platform_capabilities.dart';
import 'package:flutter/services.dart';

/// Platform channel к Android / iOS home widgets.
abstract final class AppWidgetBridge {
  static const _channel = MethodChannel('com.example.f1_pet_project/app_widgets');

  /// Пишет [data] в prefs / App Group и обновляет виджеты.
  static Future<void> saveAndUpdate({
    required Map<String, Object?> data,
    required List<String> providers,
  }) async {
    if (!PlatformCapabilities.hasHomeWidgets) {
      return;
    }
    await _channel.invokeMethod<void>('saveAndUpdate', {
      'data': data,
      'providers': providers,
    });
  }
}
