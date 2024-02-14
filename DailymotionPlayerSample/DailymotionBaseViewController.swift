//
//  DailymotionBaseViewController.swift
//  DailymotionPlayerSample
//
//  Created by Florin-Daniel DOBJENSCHI on 01.09.2023.
//

import UIKit
import GoogleCast

class DailymotionBaseViewController: UIViewController {
    let appDelegate = (UIApplication.shared.delegate as? AppDelegate) 
    override func viewDidLoad() {
        super.viewDidLoad()
        addCastButton()
        // Do any additional setup after loading the view.
    }

    override var shouldAutorotate: Bool {
        false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            .portrait
        }
    }
    
    func addCastButton() {
        let castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        castButton.tintColor = UIColor.gray
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: castButton)
    }

}
