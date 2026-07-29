package com.example.f1_pet_project

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveAndUpdate" -> {
                    @Suppress("UNCHECKED_CAST")
                    val data = call.argument<Map<String, Any?>>("data").orEmpty()
                    val providers = call.argument<List<String>>("providers").orEmpty()
                    WidgetDataStore.save(this, data)
                    WidgetUpdater.updateProviders(this, providers)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    companion object {
        private const val CHANNEL = "com.example.f1_pet_project/app_widgets"
    }
}
