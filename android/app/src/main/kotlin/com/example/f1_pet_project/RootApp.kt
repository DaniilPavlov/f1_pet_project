package com.example.f1_pet_project

import android.app.Application
import android.util.Log
import com.yandex.mapkit.MapKitFactory

class RootApp : Application() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setLocale("ru_RU")

        val apiKey = BuildConfig.YANDEX_MAPKIT_API_KEY
        if (apiKey.isBlank()) {
            Log.w(TAG, "Yandex MapKit API key is empty. Add yandex.mapkit.apiKey to android/local.properties")
        } else {
            MapKitFactory.setApiKey(apiKey)
        }
    }

    companion object {
        private const val TAG = "RootApp"
    }
}
