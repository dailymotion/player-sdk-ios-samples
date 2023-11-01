//
//  AdvertisingViewController.swift
//  DailymotionPlayerSample
//
//  Created by Florin-Daniel DOBJENSCHI on 31.08.2023.
//

import Foundation
import UIKit
import DailymotionPlayerSDK

class AdvertisingViewController: DailymotionBaseViewController {

    @IBOutlet weak var playerContainerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var playerView: DMPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Advertising Screen", comment: "")
        addConsent()
        initPlayer()
        // Do any additional setup after loading the view.
    }
    
    func addConsent() {
        UserDefaults.standard.set("CPrpw8APrpw8ABpAGAENDECsAP_AAH_AAAqIJbtV_H__bW9r8f5_aft0eY1P9_r77uQzDhfNk-4F3L_W_LwX52E7NF36tq4KmR4Eu3LBIUNlHNHUTVmwaokVryHsak2cpTNKJ6BEkHMRO2dYGF5umxtjeQKY5_p_d3fx2D-t_dv-39z3z81Xn3dZ_-_0-PCdU5_9Dfn9fRfb-9IL9_78v8v8_9_rk2_eX_3_79_7_H9-f_84JbgEmGrcQBdmUODNoGEUCIEYVhIRQKACCgGFogIAHBwU7KwCfWESAFAKAIwIgQ4AoyIBAAAJAEhEAEgRYIAAARAIAAQAIBEIAGBgEFABYCAQAAgOgYohQACBIQJEREQpgQFQJBAS2VCCUF0hphAFWWAFAIjYKABEEgIrAAEBYOAYIkBKxYIEmINogAGAFAKJUK1FJ6aAhYzIAAAA", forKey: "IABTCF_TCString")
    }
    
    func initPlayer() {
        // Add additional customisation to the player by using DMPlayerParameters struct
        var playerParams = DMPlayerParameters(mute: false)
        playerParams.customConfig = ["keyvalues":"category=travel&section=news"];
        // Using Dailymotion singleton instance in order to create the player
        // In order to get all the functionalities like fullscreen, ad support and open url pass and implement player delegate to the initialisation as bellow or after initialisation using playerView.playerDelegate = self
        // Add your player ID that was created in Dailymotion Partner HQ
        Dailymotion.createPlayer(playerId: "xix5x", videoId: "x8ned3u",playerParameters: playerParams , playerDelegate: self, adDelegate: self, logLevels: [.all]) { [weak self]  playerView, error in
            // Wait for Player initialisation and check if self is still allocated
            guard let self = self else {
                return
            }
            activityIndicator.isHidden = true
            // Checking first if the createPlayer returned an error
            if let error = error {
                self.handlePlayerError(error: error)
            } else {
                // Since playerView is optional because of a possible error it must be unwrapped first
                if let playerView = playerView {
                    // Add the Player View to view hierarchy
                    self.addPlayerView(playerView: playerView)
                }
            }
        }
    }
    
    private func addPlayerView(playerView: DMPlayerView) {
        self.playerView = playerView
        // Add the DMPlayerView as a subview to player container
        self.playerContainerView.addSubview(playerView)
        // Create constrains in order to keep the playerView flexible and adapt to layout changes
        let constraints = [
            playerView.topAnchor.constraint(equalTo: self.playerContainerView.topAnchor, constant: 0),
            playerView.bottomAnchor.constraint(equalTo: self.playerContainerView.bottomAnchor, constant: 0),
            playerView.leadingAnchor.constraint(equalTo: self.playerContainerView.leadingAnchor, constant: 0),
            playerView.trailingAnchor.constraint(equalTo: self.playerContainerView.trailingAnchor, constant: 0)
        ]
        // Activate created constraints
        NSLayoutConstraint.activate(constraints)
    }
    
    func handlePlayerError(error: Error) {
        switch(error) {
        case PlayerError.advertisingModuleMissing :
            break;
        case PlayerError.stateNotAvailable :
            break;
        case PlayerError.underlyingRemoteError(error: let error):
            let error = error as NSError
            if let errDescription = error.userInfo[NSLocalizedDescriptionKey],
               let errCode = error.userInfo[NSLocalizedFailureReasonErrorKey],
               let recovery = error.userInfo[NSLocalizedRecoverySuggestionErrorKey] {
                print("Player Error : Description: \(errDescription), Code: \(errCode), Recovery : \(recovery) ")
                
            } else {
                print("Player Error : \(error)")
            }
            break
        case PlayerError.requestTimedOut:
            print(error.localizedDescription)
            break
        case PlayerError.unexpected:
            print(error.localizedDescription)
            break
        case PlayerError.internetNotConnected:
            print(error.localizedDescription)
            break
        case PlayerError.playerIdNotFound:
            print(error.localizedDescription)
            break
        case PlayerError.otherPlayerRequestError:
            print(error.localizedDescription)
            break
        default:
            print(error.localizedDescription)
            break
        }
    }
}

extension AdvertisingViewController: DMPlayerDelegate {
    func playerWillPresentFullscreenViewController(_ player: DailymotionPlayerSDK.DMPlayerView) -> UIViewController? {
        return self
    }
    
    func playerWillPresentAdInParentViewController(_ player: DailymotionPlayerSDK.DMPlayerView) -> UIViewController {
        return self
    }
    
    func player(_ player: DailymotionPlayerSDK.DMPlayerView, openUrl url: URL) {
        UIApplication.shared.open(url)
    }
}

extension AdvertisingViewController: DMAdDelegate {
    
    func adDidReceiveCompanions(_ player: DMPlayerView) {
        print("adDidReceiveCompanions")
    }
    
    func ad(_ player: DMPlayerView, didChangeDuration duration: Double) {
        print("didChangeDuration")
    }
    
    func ad(_ player: DMPlayerView, didEnd adEndEvent: PlayerAdEndEvent) {
        print("didEnd")
    }
    
    func adDidPause(_ player: DMPlayerView) {
        print("adDidPause")
    }
    
    func adDidPlay(_ player: DMPlayerView) {
        print("adDidPlay")
    }
    
    func ad(_ player: DMPlayerView, didStart type: String, _ position: String) {
        print("didStart")
    }
    
    func ad(_ player: DMPlayerView, didChangeTime time: Double) {
        print("didChangeDuration")
    }
    
    func adDidImpression(_ player: DMPlayerView) {
        print("adDidImpression")
    }
    
    func ad(_ player: DMPlayerView, adDidLoaded adLoadedEvent: PlayerAdLoadedEvent) {
        print("adLoadedEvent")
    }
    
    func adDidClick(_ player: DMPlayerView) {
        print("adDidClick")
    }
}
