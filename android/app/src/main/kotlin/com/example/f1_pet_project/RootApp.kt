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
            Log.e(TAG, "Yandex MapKit API key is EMPTY — map tiles will stay grey")
        } else {
            Log.i(TAG, "Yandex MapKit API key present (length=${apiKey.length})")
            MapKitFactory.setApiKey(apiKey)
        }
    }

    companion object {
        private const val TAG = "RootApp"
    }
}
