//
//  PlayerStateEventButtonType.swift
//  DailymotionPlayerSample
//
//  Created by Valeriu Popa on 27.03.2024.
//

import UIKit

enum PlayerStateEventButtonType {
    case clear
    case refresh

    var image: UIImage? {
        switch self {
        case .clear: return UIImage(named: "Trashcan")
        case .refresh: return UIImage(named: "CircleArrowLeft")
        }
    }

    var title: String {
        switch self {
        case .clear: return "Clear"
        case .refresh: return "Refresh"
        }
    }
}
