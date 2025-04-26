package com.example.f1_pet_project

import android.app.Application;
import com.yandex.mapkit.MapKitFactory

class RootApp : Application() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setLocale("ru_RU"); 
        MapKitFactory.setApiKey("52bcc720-7c30-46ce-9e5a-4c0c7215a760");
    }
}
