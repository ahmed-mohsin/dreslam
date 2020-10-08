import Flutter
import UIKit
import awesome_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        //-------------------------------------------------------
        detectScreenShot {//print screen
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)//exit app
        }

        //---------------------------------------------------------
        UIScreen.main.addObserver(self, forKeyPath: "captured", options: .new, context: nil) // screen Recorder
        if #available(iOS 11.0, *) {
            if UIScreen.main.isCaptured{
                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)//exit app
            }
        } else {
            // Fallback on earlier versions
        }
        //---------------------------------------------------------
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Print Screen Handeler

    func detectScreenShot(action: @escaping () -> ()) {
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: mainQueue) { _ in
            action()
        }
    }

    // MARK: - Screen Recorder Handeler

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "captured" {
            if #available(iOS 11.0, *) {
                _ = UIScreen.main.isCaptured
            } else {
                // Fallback on earlier versions
            }
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)//exit app
        }
    }

    override func applicationDidEnterBackground(_ application: UIApplication) {
        exit(0)
    }
}
