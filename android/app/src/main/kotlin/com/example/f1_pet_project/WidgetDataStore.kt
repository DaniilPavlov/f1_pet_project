package com.example.f1_pet_project

import android.content.Context

/** SharedPreferences store used by Flutter MethodChannel and AppWidget providers. */
object WidgetDataStore {
    const val PREFS_NAME = "f1_app_widgets"

    fun prefs(context: Context) =
        context.applicationContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    fun save(context: Context, data: Map<*, *>) {
        val editor = prefs(context).edit()
        for ((rawKey, value) in data) {
            val key = rawKey as? String ?: continue
            when (value) {
                null -> editor.remove(key)
                is Boolean -> editor.putBoolean(key, value)
                is Int -> editor.putInt(key, value)
                is Long -> editor.putLong(key, value)
                is Double -> editor.putString(key, value.toString())
                is String -> editor.putString(key, value)
                else -> editor.putString(key, value.toString())
            }
        }
        editor.apply()
    }
}
