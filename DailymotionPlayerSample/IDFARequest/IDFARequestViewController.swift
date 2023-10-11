import UIKit
import AppTrackingTransparency
import AdSupport

class IDFARequestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.requestIDFA()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func requestIDFA() {
        
        if #available(iOS 14.5, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("IDFA Request: Authorized")
                    // Now that we are authorized we can get the IDFA
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("IDFA Request: Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("IDFA Request: Not Determined")
                case .restricted:
                    print("IDFA Request: Restricted")
                @unknown default:
                    print("IDFA Request: Unknown")
                }
                DispatchQueue.main.async {
                    self.navigateToMain()
                }
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                
            }
            navigateToMain()
        }
        
    }
    
    func navigateToMain() {
        let mainNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainNavigation") as? UINavigationController
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        window.rootViewController = mainNav
    }
}
