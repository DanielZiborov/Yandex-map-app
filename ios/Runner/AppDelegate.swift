import Flutter
import UIKit

import YandexMapsMobile

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    YMKMapKit.setLocale("YOUR_LOCALE") // Your preferred language. Not required, defaults to system language
    YMKMapKit.setApiKey("20b56f2e-29c8-4fd1-a2a3-bce52cfeb186") // Your generated API key
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
