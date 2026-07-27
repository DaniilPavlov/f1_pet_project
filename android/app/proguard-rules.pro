# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase / Crashlytics
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Yandex MapKit
-keep class com.yandex.** { *; }
-dontwarn com.yandex.**

# Play services (transitive)
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Flutter deferred components / Play Core (not used in this app)
-dontwarn com.google.android.play.core.**
