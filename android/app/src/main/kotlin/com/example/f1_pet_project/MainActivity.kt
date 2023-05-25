package com.example.f1_pet_project

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    MapKitFactory.setLocale("ru_RU"); 
    MapKitFactory.setApiKey("52bcc720-7c30-46ce-9e5a-4c0c7215a760");
    super.configureFlutterEngine(flutterEngine)
  }

}
