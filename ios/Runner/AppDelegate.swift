import UIKit
import Flutter
import YandexMapsMobile
import flutter_local_notifications
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private static let appWidgetsChannel = "com.example.f1_pet_project/app_widgets"

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

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    registerAppWidgetsChannel(messenger: engineBridge.applicationRegistrar.messenger())
  }

  private func registerAppWidgetsChannel(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: Self.appWidgetsChannel, binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      guard call.method == "saveAndUpdate" else {
        result(FlutterMethodNotImplemented)
        return
      }
      let args = call.arguments as? [String: Any]
      let data = args?["data"] as? [String: Any] ?? [:]
      WidgetSharedStore.save(data)
      if #available(iOS 14.0, *) {
        WidgetCenter.shared.reloadTimelines(ofKind: "NextGpWidget")
        WidgetCenter.shared.reloadTimelines(ofKind: "StandingsWidget")
      }
      result(nil)
    }
  }
}
