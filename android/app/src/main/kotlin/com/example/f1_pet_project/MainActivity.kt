package com.example.f1_pet_project

import io.flutter.embedding.android.FlutterActivity
// import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
     private val CHANNEL = "custom_notification_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "showCustomNotification") {
                NotificationService.showCustomNotification(this)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
