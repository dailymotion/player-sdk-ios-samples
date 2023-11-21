import UIKit
import DailymotionPlayerSDK
import GoogleCast

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    fileprivate var useCastContainerViewController = false
    var window: UIWindow?
    
    var isCastControlBarsEnabled: Bool {
      get {
        if useCastContainerViewController {
          let castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
          return castContainerVC!.miniMediaControlsItemEnabled
        } else {
          let rootContainerVC = (window?.rootViewController as? RootContainerViewController)
          return rootContainerVC!.miniMediaControlsViewEnabled
        }
      }
      set(notificationsEnabled) {
        guard let windowScene = UIApplication.shared.connectedScenes.filter({ $0.activationState
          == .foregroundActive }).first as? UIWindowScene,
              let window = windowScene.windows.first else {
          return
        }
        if useCastContainerViewController {
          var castContainerVC: GCKUICastContainerViewController?
          castContainerVC = (window.rootViewController as? GCKUICastContainerViewController)
          castContainerVC?.miniMediaControlsItemEnabled = notificationsEnabled
        } else {
          var rootContainerVC: RootContainerViewController?
          rootContainerVC = (window.rootViewController as? RootContainerViewController)
          rootContainerVC?.miniMediaControlsViewEnabled = notificationsEnabled
        }
      }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: FontUtils.font(type: .DailySansBulky, size: 20)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        Dailymotion.setupDailymotionChromecast()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

