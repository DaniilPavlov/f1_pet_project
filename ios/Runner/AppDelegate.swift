import UIKit
import Flutter
import YandexMapsMobile
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Нужно, чтобы плагин мог показывать уведомления, когда приложение на переднем плане,
    // и корректно обрабатывать действия из background isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    YMKMapKit.setLocale("ru_RU")

    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "YandexMapKitApiKey") as? String,
       !apiKey.isEmpty,
       apiKey != "$(YANDEX_MAPKIT_API_KEY)" {
      YMKMapKit.setApiKey(apiKey)
    } else {
      NSLog("Yandex MapKit API key is missing. Create ios/Flutter/Secrets.xcconfig with YANDEX_MAPKIT_API_KEY=...")
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
