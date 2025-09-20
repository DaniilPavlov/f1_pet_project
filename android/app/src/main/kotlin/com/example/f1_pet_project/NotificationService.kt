// NotificationService.kt
package com.example.f1_pet_project

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity

class NotificationService : FlutterActivity() {

    companion object {
        const val CHANNEL_ID = "custom_notification_channel"
        const val NOTIFICATION_ID = 1

       fun showCustomNotification(context: Context) {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            // Create a notification channel if the Android version is Oreo or higher
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Custom Notification Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            notificationManager.createNotificationChannel(channel)
            }

        // Create an intent that will be fired when the user taps the notification
        val intent = Intent(context, FlutterActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)

        // Create a RemoteViews object to use a custom layout for the notification
        val remoteViews = RemoteViews(context.packageName, R.layout.custom_notification)
        remoteViews.setTextViewText(R.id.title, "F1 App Started") // Set text for the title TextView
        remoteViews.setTextViewText(R.id.button, "Test button")

        // Build the notification
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_notification)
            .setCustomContentView(remoteViews)
            .setCustomBigContentView(remoteViews) // Ensure the big view also uses the custom layout
            .setContentIntent(pendingIntent)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .build()

        // Show the notification
        notificationManager.notify(NOTIFICATION_ID, notification)
        }
    }
}