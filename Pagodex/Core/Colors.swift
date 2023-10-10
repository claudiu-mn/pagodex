//
//  Colors.swift
//  Pagodex
//
//  Created by Claudiu Miron on 10.10.2023.
//

import UIKit

class Colors {

    /// Change this to false to enable dark mode support.
    private static let forceLight = true
    
    static let backgroundPrimary = UIColor { traits in
        return chooseColor(traitsCollection: traits,
                           light: UIColor(rgb: 0xFFFFFF),
                           dark: UIColor(rgb: 0x000000))
    }
    
    static let backgroundSecondary = UIColor { traits in
        return chooseColor(traitsCollection: traits,
                           light: UIColor(rgb: 0x0EFF2F7),
                           dark: UIColor(rgb: 0x151515))
    }
    
    static let text = UIColor { traits in
        return chooseColor(traitsCollection: traits,
                           light: UIColor(rgb: 0x161F28),
                           dark: UIColor(rgb: 0xFFFFFF))
    }
    
    // TODO: Think of a better name
    static let button = UIColor { traits in
        return UIColor(rgb: 0xC1C8D7)
    }
    
    private static func chooseColor(traitsCollection: UITraitCollection,
                                    light: UIColor,
                                    dark: UIColor) -> UIColor {
        guard !forceLight else { return light }
        
        return traitsCollection.userInterfaceStyle == .dark ? dark : light
    }
}

/// Stolen shamelessly from https://stackoverflow.com/a/35074069
extension UIColor {

    convenience init(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1.0)
    }

    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
}
