//
//  VerticalPlayerViewController.swift
//  DailymotionPlayerSample
//
//  Created by Florin-Daniel DOBJENSCHI on 31.08.2023.
//

import UIKit
import DailymotionPlayerSDK

class VerticalPlayerViewController: DailymotionBaseViewController {

    @IBOutlet weak var playerContainerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var playerView: DMPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Vertical Player", comment: "")
        initPlayer()
        // Do any additional setup after loading the view.
    }
    
    func initPlayer() {
        // Add additional customisation to the player by using DMPlayerParameters struct
        var playerParams = DMPlayerParameters(mute: false)
        playerParams.defaultFullscreenOrientation = .portrait
        // Using Dailymotion singleton instance in order to create the player
        // In order to get all the functionalities like fullscreen, ad support and open url pass and implement player delegate to the initialisation as bellow or after initialisation using playerView.playerDelegate = self
        // Add your player ID that was created in Dailymotion Partner HQ
        Dailymotion.createPlayer(playerId: "xix5x", videoId: "x8nphw7",playerParameters: playerParams , playerDelegate: self, logLevels: [.all]) { [weak self]  playerView, error in
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

extension VerticalPlayerViewController: DMPlayerDelegate {
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
