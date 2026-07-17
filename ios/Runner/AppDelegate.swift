import UIKit
import Flutter
import YandexMapsMobile

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    YMKMapKit.setLocale("ru_RU")

    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "YandexMapKitApiKey") as? String,
       !apiKey.isEmpty,
       apiKey != "$(YANDEX_MAPKIT_API_KEY)" {
      YMKMapKit.setApiKey(apiKey)
    } else {
      NSLog("Yandex MapKit API key is missing. Copy ios/Flutter/Secrets.xcconfig.example to Secrets.xcconfig")
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
