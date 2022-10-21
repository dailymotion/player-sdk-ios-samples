//
//  ViewController.swift
//  AdvancedExample
//
//  Created by Florin-Daniel DOBJENSCHI on 16.05.2022.
//

import DailymotionPlayerSDK
import UIKit

class ViewController: UIViewController {
  static let testPlayerId = "x8w3s"
  static let testVideoId = "x84sh87"
  
  // MARK: Create Player IBOutlets
  @IBOutlet weak var createPlayerButton: UIButton!
  @IBOutlet weak var createPlayerStatusLabel: UILabel!
  @IBOutlet weak var createPlayerLoadingIndicator: UIActivityIndicatorView!
  @IBOutlet weak var createPlayerStackView: UIStackView!
  
  // MARK: Container View IBOutlet
  @IBOutlet weak var playerContainerView: UIView!
  
  // MARK: Player Commands IBOutlets
  @IBOutlet weak var loadButton: UIButton!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var pauseButton: UIButton!
  @IBOutlet weak var muteButton: UIButton!
  @IBOutlet weak var unMuteButton: UIButton!
  @IBOutlet weak var setSubtitleButton: UIButton!
  @IBOutlet weak var showControlsButton: UIButton!
  @IBOutlet weak var hideControlsButton: UIButton!
  @IBOutlet weak var setScaleButton: UIButton!
  @IBOutlet weak var seekToButton: UIButton!
  @IBOutlet weak var setQualityButton: UIButton!
  @IBOutlet weak var setCustomConfigButton: UIButton!
  @IBOutlet weak var setFullscreenButton: UIButton!
  @IBOutlet weak var updateParametersButton: UIButton!
  
  @IBOutlet weak var playerEventsLogsTextView: UITextView!
  var lastPlayerEventLogContentOffset: CGFloat = 0
  var blockPlayerEventLogAutoScroll = false
  // MARK: Player Stuff
  var playerView: DMPlayerView?
  var videoSubtitleArray: [String]?
  var videoQualitiesArray: [String]?
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
    // Do any additional setup after loading the view.
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.portrait
  }
  
  func setupView() {
    self.createPlayerStatusLabel.isHidden = true
    self.createPlayerLoadingIndicator.stopAnimating()
    
    self.loadButton.isEnabled = false
    self.playButton.isEnabled = false
    self.pauseButton.isEnabled = false
    self.muteButton.isEnabled = false
    self.unMuteButton.isEnabled = false
    self.setSubtitleButton.isEnabled = false
    self.showControlsButton.isEnabled = false
    self.hideControlsButton.isEnabled = false
    self.setScaleButton.isEnabled = false
    self.seekToButton.isEnabled = false
    self.setQualityButton.isEnabled = false
    self.setCustomConfigButton.isEnabled = false
    self.setFullscreenButton.isEnabled = false
    self.updateParametersButton.isEnabled = false
  }
  
  
  // Create the player
  private func setupPlayerView() {
    setupPlayerLogsTextView()
    self.createPlayerLoadingIndicator.startAnimating()	
    self.createPlayerStackView.isHidden = false
    self.createPlayerStatusLabel.isHidden = false
    self.createPlayerStatusLabel.text = "Player Loading..."
    
    // Add additional customisation to the player by using DMPlayerParameters struct
    let playerParams = DMPlayerParameters(mute: false)
    // Using Dailymotion singleton instance in order to create the player
    // In order to get all the functionalities like fullscreen, ad support and open url pass and implement player delegate to the initialisation as bellow or after initialisation using playerView.playerDelegate = self
    Dailymotion.createPlayer(playerId: ViewController.testPlayerId, videoId: ViewController.testVideoId, playerParameters: playerParams , playerDelegate: self, videoDelegate: self, adDelegate: self) { [weak self] playerView, error in
      // Wait for Player initialisation and check if self is still allocated
      guard let self = self else {
        return
      }
      self.createPlayerLoadingIndicator.stopAnimating()
      // Checking first if the createPlayer returned an error
      if let error = error {
        self.createPlayerButton.isHidden = false
        self.createPlayerStatusLabel.text = error.localizedDescription
        self.logPlayerEvent(event: "Error creating player \(error)")
      } else {
        self.createPlayerStatusLabel.isHidden = true
        self.createPlayerStackView.isHidden = true
        // Since playerView is optional because of a possible error it must be unwrapped first
        if let playerView = playerView {
          // Add the Player View to view hierarchy
          self.addPlayerView(playerView: playerView)
          self.enablePlayerControls()
          self.logPlayerEvent(event: "Player Created")
        }
      }
    }
  }
  
  private func setupPlayerLogsTextView() {
    playerEventsLogsTextView.text = ""
    playerEventsLogsTextView.layer.borderColor = UIColor.black.cgColor
    playerEventsLogsTextView.layer.borderWidth = 1.0
    playerEventsLogsTextView.layoutManager.allowsNonContiguousLayout = false
    playerEventsLogsTextView.delegate = self
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
  
  private func enablePlayerControls() {
    self.loadButton.isEnabled = true
    self.playButton.isEnabled = true
    self.pauseButton.isEnabled = true
    self.muteButton.isEnabled = true
    self.unMuteButton.isEnabled = true
    self.showControlsButton.isEnabled = true
    self.hideControlsButton.isEnabled = true
    self.setScaleButton.isEnabled = true
    self.seekToButton.isEnabled = true
    self.setCustomConfigButton.isEnabled = true
    self.setFullscreenButton.isEnabled = true
    self.updateParametersButton.isEnabled = true
  }
  
  // MARK: IBActions
  @IBAction func createPlayerBtnPressed(_ sender: Any) {
    setupPlayerView()
    self.createPlayerButton.isHidden = true
  }
  
  @IBAction func loadVideoBtnPressed(_ sender: Any) {
    playerView?.loadContent(videoId: "x84s8c8", playlistId: "x79dlo", startTime: 20)
  }
  
  @IBAction func playVideoBtnPressed(_ sender: Any) {
    playerView?.play()
  }
  
  @IBAction func pauseVideoBtnPressed(_ sender: Any) {
    playerView?.pause()
  }
  
  @IBAction func muteVideoBtnPressed(_ sender: Any) {
    playerView?.setMute(mute: true)
  }
  
  @IBAction func unMuteVideoBtnPressed(_ sender: Any) {
    playerView?.setMute(mute: false)
  }
  
  @IBAction func setVideoSubtitleBtnPressed(_ sender: UIButton) {
    guard let subtitles = videoSubtitleArray else {
      return
    }
    
    let data: [[String]] = [subtitles]
    McPicker.showAsPopover(data: data, fromViewController: self, sourceView: sender) { [weak self] (selections: [Int: String]) -> Void in
      if let captionSelected = selections[0] {
        self?.playerView?.setSubtitles(code: captionSelected)
      }
    }
  }
  
  @IBAction func showVideoControlsBtnPressed(_ sender: Any) {
    playerView?.setControls(visible: true)
  }
  
  @IBAction func hideVideoControlsBtnPressed(_ sender: Any) {
    playerView?.setControls(visible: false)
  }
  
  @IBAction func setVideoScaleBtnPressed(_ sender: UIButton) {
    let cases = DMPlayerParameters.ScaleMode.allCases
    var valuesString: [String] = []
    for value in cases {
      valuesString.append(value.rawValue)
    }
    let data: [[String]] = [valuesString]
    McPicker.showAsPopover(data: data, fromViewController: self, sourceView: sender) { [weak self] (selections: [Int: String]) -> Void in
      if let scaleSelected = selections[0] {
        let selected = DMPlayerParameters.ScaleMode.init(rawValue: scaleSelected)
        if let selected = selected {
          self?.playerView?.setScaleMode(scaleMode: selected)
        }
      }
    }
  }
  
  @IBAction func videoSeekToBtnPressed(_ sender: Any) {
    showInputDialog(title: "Seek To",
                    subtitle: "Enter the value where you want to Seek",
                    actionTitle: "OK",
                    cancelTitle: "Cancel",
                    inputPlaceholder: "Seek Value",
                    inputKeyboardType: .numberPad, actionHandler:
                      {[weak self] (input: String?) in
      guard let stringValue = input, let ti = TimeInterval(stringValue) else {
        return
      }
      
      self?.playerView?.seek(to: ti)
    })
  }
  
  @IBAction func setVideoQualityBtnPressed(_ sender: UIButton) {
    guard let qualities = videoQualitiesArray else {
      print("No Qualities available")
      return
    }
    
    let data: [[String]] = [qualities]
    McPicker.showAsPopover(data: data, fromViewController: self, sourceView: sender) { [weak self] (selections: [Int: String]) -> Void in
      if let qualitySelected = selections[0] {
        self?.playerView?.setQuality(level: qualitySelected)
      }
    }
  }
  
  @IBAction func setCustomConfigBtnPressed(_ sender: Any) {
    showInputDialog(title: "Ads config",
                    subtitle: "Enter ads config",
                    actionTitle: "OK",
                    cancelTitle: "Cancel",
                    inputPlaceholder: "Ads config",
                    inputKeyboardType: .default, actionHandler:
                      {[weak self] (input: String?) in
      guard let stringValue = input else {
        return
      }
      
      self?.playerView?.setCustomConfig(config: stringValue)
    })
  }
  
  @IBAction func setFullscreenBtnPressed(_ sender: Any) {
    self.playerView?.setFullscreen(fullscreen: true)
  }
  
  @IBAction func updateParamsBtnPressed(_ sender: Any) {
    let newPlayerParameters = DMPlayerParameters(scaleMode:.fill, mute: true)
    self.playerView?.updateParams(params: newPlayerParameters)
  }
}

// MARK: Implementation of DMPlayerDelegate
extension ViewController: DMPlayerDelegate {
  func player(_ player: DMPlayerView, openUrl url: URL) {
    logPlayerEvent(event: "Open Url : \(url)")
    UIApplication.shared.open(url)
  }
  
  func playerWillPresentFullscreenViewController(_ player: DMPlayerView) -> UIViewController {
    logPlayerEvent(event: "Present Fullscreen ViewController")
    return self
  }
  
  func playerWillPresentAdInParentViewController(_ player: DMPlayerView) -> UIViewController {
    logPlayerEvent(event: "Present Ad In Parent ViewController")
    return self
  }
  
  func player(_ player: DMPlayerView, didFailWithError error: Error) {
    logPlayerEvent(event: "Did Failed With Error: \(error.localizedDescription)")
  }
  
  func player(_ player: DMPlayerView, didChangeControls isVisible: Bool) {
    logPlayerEvent(event: "Control Changed, visible: \(isVisible)")
  }
  
  func playerDidStart(_ player: DMPlayerView) {
    logPlayerEvent(event: "Did Start")
  }
  
  func playerDidEnd(_ player: DMPlayerView) {
    logPlayerEvent(event: "Did End")
  }
  
  func player(_ player: DMPlayerView, didChangeVideo changedVideoEvent: PlayerVideoChangeEvent) {
    logPlayerEvent(event: "Did Video Change id: \(changedVideoEvent.videoId ?? "") ")
    videoQualitiesArray = nil
    videoSubtitleArray = nil
    setSubtitleButton.isEnabled = false
    setQualityButton.isEnabled = false
  }
  
  func player(_ player: DMPlayerView, didChangeVolume volume: Double, _ muted: Bool) {
    logPlayerEvent(event: "Audio Changed volume: \(volume), muted: \(muted) ")
  }

  func playerDidCriticalPathReady(_ player: DMPlayerView) {
    logPlayerEvent(event: "Did Playback Ready")
  }
  
  func player(_ player: DMPlayerView, didReceivePlaybackPermission playbackPermission: PlayerPlaybackPermission) {
    logPlayerEvent(event: "Playback Permission : status:\(playbackPermission.status), reason:\(playbackPermission.reason)")
  }
  
  func player(_ player: DMPlayerView, didChangePresentationMode presentationMode: DMPlayerView.PresentationMode) {
    var presentationModeString = "None"
    switch presentationMode {
    case .fullscreen:
      presentationModeString = "Full Screen"
    case .inline:
      presentationModeString = "Inline"
    case .pictureInPicture:
      presentationModeString = "Picture In Picture"
    default: break
    }
    logPlayerEvent(event: "Did Presentation Mode Change to : \(presentationModeString)")
  }
  
  func player(_ player: DMPlayerView, didChangeScaleMode scaleMode: String) {
    logPlayerEvent(event: "Scale Mode Change to \(scaleMode)")
  }
}

// MARK: Implementation of DMVideoDelegate
extension ViewController: DMVideoDelegate {
  func video(_ player: DMPlayerView, didChangeSubtitles subtitles: String) {
    logVideoEvent(event: "Subtitle Change : \(subtitles)")
  }
  
  func video(_ player: DMPlayerView, didReceiveSubtitlesList subtitlesList: [String]) {
    logVideoEvent(event: "Subtitle List Available: \(subtitlesList)")
    setSubtitleButton.isEnabled = true
    videoSubtitleArray = subtitlesList
  }
  
  func video(_ player: DMPlayerView, didChangeDuration duration: Double) {
    logVideoEvent(event: "Duration changed: \(duration)")
  }
  
  func videoDidEnd(_ player: DMPlayerView) {
    logVideoEvent(event: "End")
  }
  
  func videoDidPause(_ player: DMPlayerView) {
    logVideoEvent(event: "Paused")
  }
  
  func videoDidPlay(_ player: DMPlayerView) {
    logVideoEvent(event: "Play")
  }
  
  func videoIsPlaying(_ player: DMPlayerView) {
    logVideoEvent(event: "Is Playing")
  }
  
  func video(_ player: DMPlayerView, isInProgress progressTime: Double) {
    logVideoEvent(event: "Is in progress: \(progressTime)")
  }
  
  func video(_ player: DMPlayerView, didReceiveQualitiesList qualities: [String]) {
    logVideoEvent(event: "Qualities Available: \(qualities)")
    setQualityButton.isEnabled = true
    self.videoQualitiesArray = qualities
  }
    
  func video(_ player: DMPlayerView, didSeekStart time: Double) {
    logVideoEvent(event: "didSeekStart: \(time)")
  }
    
  func video(_ player: DMPlayerView, didSeekEnd time: Double) {
    logVideoEvent(event: "didSeekEnd: \(time)")
  }
  
  func video(_ player: DMPlayerView, didChangeQuality quality: String) {
    logVideoEvent(event: "Quality Changed: \(quality)")
  }
  
  func videoDidStart(_ player: DMPlayerView){
    logVideoEvent(event: "Did start")
  }
  
  func video(_ player: DMPlayerView, didChangeTime time: Double) {
    logVideoEvent(event:String(format: "Time: %.2f", time))
  }
  
  func videoIsBuffering(_ player: DMPlayerView) {
    logVideoEvent(event: "Is Waiting")
  }
}

// MARK: Implementation of DMAdDelegate
extension ViewController: DMAdDelegate {
  
  func adDidReceiveCompanions(_ player: DMPlayerView) {
    logAdEvent(event: "Receive Companions")
  }
  
  func ad(_ player: DMPlayerView, didChangeDuration duration: Double) {
    logAdEvent(event: "Duration Changed : \(duration)")
  }
  
  func ad(_ player: DMPlayerView, didEnd adEndEvent: PlayerAdEndEvent) {
    logAdEvent(event: "End")
  }
  
  func adDidPause(_ player: DMPlayerView) {
    logAdEvent(event: "Pause")
  }
  
  func adDidPlay(_ player: DMPlayerView) {
    logAdEvent(event: "Pause")
  }
  
  func ad(_ player: DMPlayerView, didStart type: String, _ position: String) {
    logAdEvent(event: "Start, Type: \(type), Poz: \(position)")
  }
  
  func ad(_ player: DMPlayerView, didChangeTime time: Double) {
    logAdEvent(event: "Time Changed : \(time)")
  }
  
  func adDidImpression(_ player: DMPlayerView) {
    logAdEvent(event: "Impression")
  }
  
  func ad(_ player: DMPlayerView, adDidLoaded adLoadedEvent: PlayerAdLoadedEvent) {
    logAdEvent(event: "Loaded")
  }
  
  func adDidClick(_ player: DMPlayerView) {
    logAdEvent(event: "Click")
  }
}

extension UIViewController {
  func showInputDialog(title: String? = nil,
                       subtitle: String? = nil,
                       actionTitle: String? = "OK",
                       cancelTitle: String? = "Cancel",
                       inputPlaceholder: String? = nil,
                       inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                       cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                       actionHandler: ((_ text: String?) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
    alert.addTextField { (textField: UITextField) in
      textField.placeholder = inputPlaceholder
      textField.keyboardType = inputKeyboardType
    }
    alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action: UIAlertAction) in
      guard let textField =  alert.textFields?.first else {
        actionHandler?(nil)
        return
      }
      actionHandler?(textField.text)
    }))
    alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
    
    self.present(alert, animated: true, completion: nil)
  }
}

extension ViewController: UITextViewDelegate {
  private func logPlayerEvent(event: String) {
    logEvent(event: "Player: \(event)")
  }
  
  private func logVideoEvent(event: String) {
    logEvent(event: "Video: \(event)")
  }
  
  private func logAdEvent(event: String) {
    logEvent(event: "Ad: \(event)")
  }
  
  private func logEvent(event: String) {
    self.playerEventsLogsTextView.text = "\(playerEventsLogsTextView.text ?? "") \n \(event)"
    if (blockPlayerEventLogAutoScroll == false) {
      let stringLength: Int = playerEventsLogsTextView.text.count
      playerEventsLogsTextView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
    if (bottomEdge >= scrollView.contentSize.height) {
      blockPlayerEventLogAutoScroll = false
      return
    }
    if (lastPlayerEventLogContentOffset > scrollView.contentOffset.y) {
      blockPlayerEventLogAutoScroll = true
    }
    lastPlayerEventLogContentOffset = scrollView.contentOffset.y
  }
}
