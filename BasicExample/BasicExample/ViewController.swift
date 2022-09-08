//
//  ViewController.swift
//  BasicExample
//
//  Copyright © 2022 Dailymotion. All rights reserved.
//

import UIKit
import DailymotionPlayerSDK

class ViewController: UIViewController {
  
  @IBOutlet weak var playerContainerView: UIView!
  
  @IBOutlet weak var createPlayerStackView: UIStackView!
  @IBOutlet weak var createPlayerStatusLabel: UILabel!
  @IBOutlet weak var createPlayerLoadingIndicator: UIActivityIndicatorView!
  @IBOutlet weak var createPlayerButton: UIButton!
  
  var playerView: DMPlayerView?
  static let testPlayerId = "x8w3s"
  static let testVideoId = "x84sh87"
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.createPlayerStatusLabel.isHidden = true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.portrait
  }
  
  @IBAction func createPlayerBtnPressed(_ sender: Any) {
    self.createPlayerButton.isHidden = true
    setupPlayerView()
    
  }
  
  // Create the player
  private func setupPlayerView() {
    self.createPlayerLoadingIndicator.startAnimating()
    self.createPlayerStackView.isHidden = false
    self.createPlayerStatusLabel.isHidden = false
    self.createPlayerStatusLabel.text = "Player Loading..."
    
    // Add additional customisation to the player by using DMPlayerParameters struct
    let playerParams = DMPlayerParameters(mute: false)
    // Using Dailymotion singleton instance in order to create the player
    // In order to get all the functionalities like fullscreen, ad support and open url pass and implement player delegate to the initialisation as bellow or after initialisation using playerView.playerDelegate = self
    Dailymotion.createPlayer(playerId: ViewController.testPlayerId, videoId: ViewController.testVideoId, playerParameters: playerParams , playerDelegate: self) { [weak self] playerView, error in
      // Wait for Player initialisation and check if self is still allocated
      guard let self = self else {
        return
      }
      self.createPlayerLoadingIndicator.stopAnimating()
      // Checking first if the createPlayer returned an error
      if let error = error {
        self.createPlayerButton.isHidden = false
        self.createPlayerStatusLabel.text = error.localizedDescription
      } else {
        
        // Since playerView is optional because of a possible error it must be unwrapped first
        if let playerView = playerView {
          self.createPlayerStackView.isHidden = true
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
}

extension ViewController: DMPlayerDelegate {
  func player(_ player: DMPlayerView, openUrl url: URL) {
    UIApplication.shared.open(url)
  }
  
  func playerWillPresentFullscreenViewController(_ player: DMPlayerView) -> UIViewController {
    return self
  }
  
  func playerWillPresentAdInParentViewController(_ player: DMPlayerView) -> UIViewController {
    return self
  }
}

