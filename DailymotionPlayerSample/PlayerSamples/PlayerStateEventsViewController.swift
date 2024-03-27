//
//  VerticalPlayerViewController.swift
//  DailymotionPlayerSample
//
//  Created by Florin-Daniel DOBJENSCHI on 31.08.2023.
//

import UIKit
import DailymotionPlayerSDK
import Combine

class PlayerStateEventsViewController: DailymotionBaseViewController {
    @IBOutlet weak var playerContainerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stateEventsViewContainer: UIView!
    @IBOutlet weak var eventsBtn: UIButton!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var eventsStateTextView: UITextView!
    @IBOutlet weak var stateLogsBtn: UIButton!
    
    var playerView: DMPlayerView?
    var dailymotionEvents: [String] = []
    var textViewAutoScroll = false
    var lastTextViewContentOffset: CGFloat = 0
    var stateLogsBtnType: PlayerStateEventButtonType = .clear {
        didSet {
            stateLogsBtn.setTitle(stateLogsBtnType.title, for: .normal)
            stateLogsBtn.setImage(stateLogsBtnType.image, for: .normal)
        }
    }

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Player Events & State", comment: "")
        initPlayer()
        setupView()
        // Do any additional setup after loading the view.
        stateLogsBtnType = .clear
    }
    
    // MARK: @IBActions
    
    @IBAction func eventsBtn(_ sender: UIButton) {
        eventsStateTextView.text = ""
        eventsBtn.isSelected = true
        stateBtn.isSelected = false
        var eventsText = ""
        for dailymotionEvent in dailymotionEvents {
            eventsText = eventsText + dailymotionEvent + "\n"
        }
        eventsStateTextView.text = eventsText
        scrollToBottom()
        stateLogsBtnType = .clear
    }
    
    @IBAction func stateBtn(_ sender: UIButton) {
        stateBtn.isSelected = true
        eventsBtn.isSelected = false
        eventsStateTextView.text = ""
        playerView?.getState(completion: { [weak self] state in
            self?.eventsStateTextView.text = state?.description
        })
        stateLogsBtnType = .refresh
    }

    @IBAction func stateLogsBtn(_ sender: Any) {
        switch stateLogsBtnType {
        case .clear:
            dailymotionEvents.removeAll()
            clearOutputView()
        case .refresh:
            clearOutputView()
            playerView?.getState(completion: { [weak self] state in
                self?.eventsStateTextView.text = state?.description
            })
        }
    }

    func clearOutputView() {
        eventsStateTextView.text = nil
    }

    // MARK: Setup
    
    func setupView() {
        stateEventsViewContainer.layer.shadowColor = UIColor(red: 0.051, green: 0.051, blue: 0.051, alpha: 0.6).cgColor
        stateEventsViewContainer.layer.cornerRadius = 20
        stateEventsViewContainer.layer.shadowOpacity = 1
        stateEventsViewContainer.layer.shadowRadius = 40
        stateEventsViewContainer.layer.shadowOffset = CGSize(width: 0, height: 12)
        eventsStateTextView.text = ""
        eventsBtn.isSelected = true
        stateBtn.isSelected = false
        eventsStateTextView.delegate = self

        stateLogsBtn.layer.cornerRadius = 12
        stateLogsBtn.layer.borderWidth = 2
        stateLogsBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    func initPlayer() {
        // Add additional customisation to the player by using DMPlayerParameters struct
        var playerParams = DMPlayerParameters(mute: false)
        playerParams.defaultFullscreenOrientation = .portrait
        // Using Dailymotion singleton instance in order to create the player
        // In order to get all the functionalities like fullscreen, ad support and open url pass and implement player delegate to the initialisation as bellow or after initialisation using playerView.playerDelegate = self
        // Add your player ID that was created in Dailymotion Partner HQ
        Dailymotion.createPlayer(playerId: "xix5x", videoId: "x84sh87",playerParameters: playerParams , playerDelegate: self, videoDelegate: self, adDelegate: self, logLevels: [.all]) { [weak self]  playerView, error in
            // Wait for Player initialisation and check if self is still allocated
            guard let self = self else {
                return
            }
            self.activityIndicator.isHidden = true
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
    
    func addPlayerView(playerView: DMPlayerView) {
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
    
    // MARK: Utils
    
    func addPlayerEvent(event: String) {
        dailymotionEvents.append(event)
        if eventsBtn.isSelected {
            eventsStateTextView.text = eventsStateTextView.text + event + "\n"
            if textViewAutoScroll == false {
                scrollToBottom()
            }
        }
    }
    
    func scrollToBottom() {
        let stringLength: Int = eventsStateTextView.text.count
        eventsStateTextView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
    }
}
// MARK: DMPlayerDelegate
extension PlayerStateEventsViewController: DMPlayerDelegate {
    func playerWillPresentFullscreenViewController(_ player: DailymotionPlayerSDK.DMPlayerView) -> UIViewController? {
        addPlayerEvent(event: "playerWillPresentFullscreenViewController")
        return self
    }
    
    func playerWillPresentAdInParentViewController(_ player: DailymotionPlayerSDK.DMPlayerView) -> UIViewController {
        addPlayerEvent(event: "playerWillPresentAdInParentViewController")
        return self
    }
    
    func player(_ player: DailymotionPlayerSDK.DMPlayerView, openUrl url: URL) {
        addPlayerEvent(event: "playerOpenUrl")
        UIApplication.shared.open(url)
    }
    
    func player(_ player: DMPlayerView, didFailWithError error: Error) {
        addPlayerEvent(event: "playerDidFailWithError")
    }
    
    func player(_ player: DMPlayerView, didChangeControls isVisible: Bool) {
        addPlayerEvent(event: "playerDidChangeControls")
    }
    
    func playerDidStart(_ player: DMPlayerView) {
        addPlayerEvent(event: "playerDidStart")
    }
    
    func playerDidEnd(_ player: DMPlayerView) {
        addPlayerEvent(event: "playerDidEnd")
    }
    
    func player(_ player: DMPlayerView, didChangeVideo changedVideoEvent: PlayerVideoChangeEvent) {
        addPlayerEvent(event: "playerDidChangeVideo")
    }
    
    func player(_ player: DMPlayerView, didChangeVolume volume: Double, _ muted: Bool) {
        addPlayerEvent(event: "playerDidChangeVolume")
    }
    
    func playerDidCriticalPathReady(_ player: DMPlayerView) {
        addPlayerEvent(event: "playerDidCriticalPathReady")
    }
    
    func player(_ player: DMPlayerView, didReceivePlaybackPermission playbackPermission: PlayerPlaybackPermission) {
        addPlayerEvent(event: "playerDidReceivePlaybackPermission")
    }
    
    func player(_ player: DMPlayerView, didChangePresentationMode presentationMode: DMPlayerView.PresentationMode) {
        addPlayerEvent(event: "playerDidChangePresentationMode")
    }
    
    func player(_ player: DMPlayerView, didChangeScaleMode scaleMode: String) {
        addPlayerEvent(event: "playerDidChangeScaleMode")
    }
    
}
// MARK: DMVideoDelegate
extension PlayerStateEventsViewController: DMVideoDelegate {
    func video(_ player: DMPlayerView, didChangeSubtitles subtitles: String) {
        addPlayerEvent(event: "videoDidChangeSubtitles")
    }
    
    func video(_ player: DMPlayerView, didReceiveSubtitlesList subtitlesList: [String]) {
        addPlayerEvent(event: "videoDidReceiveSubtitlesList")
    }
    
    func video(_ player: DMPlayerView, didChangeDuration duration: Double) {
        addPlayerEvent(event: "videoDidChangeDuration")
    }
    
    func videoDidEnd(_ player: DMPlayerView) {
        addPlayerEvent(event: "videoDidEnd")
    }
    
    func videoDidPause(_ player: DMPlayerView) {
        addPlayerEvent(event: "videoDidPause")
    }
    
    func videoDidPlay(_ player: DMPlayerView) {
        addPlayerEvent(event: "videoDidPlay")
    }
    
    func videoIsPlaying(_ player: DMPlayerView) {
        addPlayerEvent(event: "videoIsPlaying")
    }
    
    func video(_ player: DMPlayerView, isInProgress progressTime: Double) {
        addPlayerEvent(event: "videoIsInProgress")
    }
    
    func video(_ player: DMPlayerView, didReceiveQualitiesList qualities: [String]) {
        addPlayerEvent(event: "videoDidReceiveQualitiesList")
    }
    
    func video(_ player: DMPlayerView, didChangeQuality quality: String) {
        addPlayerEvent(event: "videoDidChangeQuality")
    }
    
    func video(_ player: DMPlayerView, didSeekEnd time: Double) {
        addPlayerEvent(event: "videoDidSeekEnd")
    }
    
    func video(_ player: DMPlayerView, didSeekStart time: Double) {
        addPlayerEvent(event: "videoDidSeekStart")
    }
    
    func videoDidStart(_ player: DMPlayerView) {
        addPlayerEvent(event: "videoDidStart")
    }
    
    func video(_ player: DMPlayerView, didChangeTime time: Double) {
//        addPlayerEvent(event: "videoDidChangeTime")
    }
    
    func videoIsBuffering(_ player: DMPlayerView) {
        addPlayerEvent(event: "videoIsBuffering")
    }
}
// MARK: DMAdDelegate
extension PlayerStateEventsViewController: DMAdDelegate {
    func adDidReceiveCompanions(_ player: DMPlayerView) {
        addPlayerEvent(event: "adDidReceiveCompanions")
    }
    
    func ad(_ player: DMPlayerView, didChangeDuration duration: Double) {
        addPlayerEvent(event: "didChangeDuration")
    }
    
    func ad(_ player: DMPlayerView, didEnd adEndEvent: PlayerAdEndEvent) {
        addPlayerEvent(event: "adDidEnd")
    }
    
    func adDidPause(_ player: DMPlayerView) {
        addPlayerEvent(event: "adDidPause")
    }
    
    func adDidPlay(_ player: DMPlayerView) {
        addPlayerEvent(event: "adDidPlay")
    }
    
    func ad(_ player: DMPlayerView, didStart type: String, _ position: String) {
        addPlayerEvent(event: "adDidStart")
    }
    
    func ad(_ player: DMPlayerView, didChangeTime time: Double) {
        addPlayerEvent(event: "adDidChangeTime")
    }
    
    func adDidImpression(_ player: DMPlayerView) {
        addPlayerEvent(event: "adDidImpression")
    }
    
    func ad(_ player: DMPlayerView, adDidLoaded adLoadedEvent: PlayerAdLoadedEvent) {
        addPlayerEvent(event: "adDidLoaded")
    }
    
    func adDidClick(_ player: DMPlayerView) {
        addPlayerEvent(event: "adDidClick")
    }
}
// MARK: DMPlayerState CustomStringConvertible
extension DMPlayerState: CustomStringConvertible {
    /// Returns a `String` representation of the `LogLevel`.
    public var description: String {
        var description = ""
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {
            if let propertyName = child.label {
                var value = String.init(describing: child.value)
                if let range = value.range(of: "Optional(") {
                    value.removeSubrange(range)
                    if let range = value.range(of: ")") {
                        value.removeSubrange(range)
                    }
                }
                description += "\(propertyName): \(value)"
                description += "\n"
            }
        }
        return description
    }
}

extension PlayerStateEventsViewController: UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if (bottomEdge >= scrollView.contentSize.height) {
            textViewAutoScroll = false
            return
        }
        if (lastTextViewContentOffset > scrollView.contentOffset.y) {
            textViewAutoScroll = true
        }
        lastTextViewContentOffset = scrollView.contentOffset.y
    }
}
