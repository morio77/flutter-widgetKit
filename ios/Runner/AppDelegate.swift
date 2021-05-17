import UIKit
import Flutter
import WidgetKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "work.hondakenya.flutterWidgetkit/sample",
                                       binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

        guard call.method == "setCounterForWidgetKit" else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        self.setUserDefaultsForAppGroup(result: result)
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func setUserDefaultsForAppGroup(result: FlutterResult) {

        guard let userDefaults = UserDefaults(suiteName: "group.counter.hondakenya.sample") else {
            return result(FlutterError(code: "UNAVAILABLE",
                                       message: "setUserDefaultsForAppGroup Failed",
                                       details: nil))
        }

        // 1: FlutterのSharedPreferencesから取得
        let defaults = UserDefaults.standard
        let counter = defaults.integer(forKey: "flutter.counter")

        // 2: 1の結果をAppGroupのDefaultsに保存
        userDefaults.setValue(counter, forKey: "counter")
        
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        result(userDefaults.integer(forKey: "counter"))
        
        result(counter)
    }
}
