//
//  FontUtils.swift
//  DailymotionPlayerSample
//
//  Created by Florin-Daniel DOBJENSCHI on 31.08.2023.
//

import Foundation
import UIKit

enum DailymotionFont: String {
    case ABCFavoritBold = "ABCFavorit-Bold"
    case ABCFavoritBook = "ABCFavorit-Book"
    case ABCFavoritMedium = "ABCFavorit-Medium"
    case ABCFavoritRegular = "ABCFavorit-Regular"
    case ABCFavoritMonoRegular = "ABCFavoritMono-Regular"
    case DailySansBulky = "DailySans-Bulky"
}

struct FontUtils {
    static func font(type: DailymotionFont, size: CGFloat) -> UIFont {
        guard let dmFont = UIFont(name: type.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return dmFont
    }
}
