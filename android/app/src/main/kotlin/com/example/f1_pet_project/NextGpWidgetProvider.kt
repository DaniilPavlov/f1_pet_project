package com.example.f1_pet_project

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.os.SystemClock
import android.view.View
import android.widget.RemoteViews

class NextGpWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        val data = WidgetDataStore.prefs(context)
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_next_gp).apply {
                setOnClickPendingIntent(
                    R.id.widget_next_gp_root,
                    WidgetUpdater.launchAppPendingIntent(context),
                )

                val hasData = data.getBoolean(KEY_HAS_DATA, false)
                if (!hasData) {
                    setViewVisibility(R.id.widget_next_gp_content, View.GONE)
                    setViewVisibility(R.id.widget_next_gp_empty, View.VISIBLE)
                    setTextViewText(R.id.widget_next_gp_empty, context.getString(R.string.widget_open_app))
                    return@apply
                }

                setViewVisibility(R.id.widget_next_gp_content, View.VISIBLE)
                setViewVisibility(R.id.widget_next_gp_empty, View.GONE)

                val raceName = data.getString(KEY_RACE_NAME, null)
                    ?: context.getString(R.string.widget_next_gp_title)
                val circuit = data.getString(KEY_CIRCUIT, "") ?: ""
                setTextViewText(R.id.widget_next_gp_race, raceName)
                setTextViewText(R.id.widget_next_gp_circuit, circuit)
                setViewVisibility(
                    R.id.widget_next_gp_circuit,
                    if (circuit.isBlank()) View.GONE else View.VISIBLE,
                )

                val targetMs = data.getString(KEY_TARGET_MS, null)?.toLongOrNull() ?: 0L
                val remaining = targetMs - System.currentTimeMillis()
                if (remaining <= 0L) {
                    setTextViewText(R.id.widget_next_gp_days, "0")
                    setChronometer(R.id.widget_next_gp_chrono, SystemClock.elapsedRealtime(), null, false)
                    setTextViewText(R.id.widget_next_gp_status, context.getString(R.string.widget_next_gp_started))
                    setViewVisibility(R.id.widget_next_gp_status, View.VISIBLE)
                } else {
                    val days = remaining / DAY_MS
                    val remAfterDays = remaining % DAY_MS
                    setTextViewText(R.id.widget_next_gp_days, days.toString().padStart(2, '0'))
                    setChronometer(
                        R.id.widget_next_gp_chrono,
                        SystemClock.elapsedRealtime() + remAfterDays,
                        null,
                        true,
                    )
                    setChronometerCountDown(R.id.widget_next_gp_chrono, true)
                    setViewVisibility(R.id.widget_next_gp_status, View.GONE)
                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    companion object {
        private const val DAY_MS = 86_400_000L
        private const val KEY_HAS_DATA = "next_gp_has_data"
        private const val KEY_RACE_NAME = "next_gp_race_name"
        private const val KEY_CIRCUIT = "next_gp_circuit"
        private const val KEY_TARGET_MS = "next_gp_target_ms"
    }
}
