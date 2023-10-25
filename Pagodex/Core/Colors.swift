//
//  Colors.swift
//  Pagodex
//
//  Created by Claudiu Miron on 10.10.2023.
//

import UIKit

final class Colors {
    
    private init() { }
    
    /// Change this to false to enable dark mode support.
    private static let forceLight = false
    
    static let backgroundPrimary = UIColor { traits in
        return chooseObject(traitCollection: traits,
                            light: UIColor(rgb: 0xFFFFFF),
                            dark: UIColor(rgb: 0x000000))
    }
    
    static let backgroundSecondary = UIColor { traits in
        return chooseObject(traitCollection: traits,
                            light: UIColor(rgb: 0x0EFF2F7),
                            dark: UIColor(rgb: 0x151515))
    }
    
    // TODO: Think of a better name
    static let backgroundTertiary = UIColor { traits in
        return UIColor(rgb: 0xC1C8D7)
    }
    
    static func statusBarStyle(for traits: UITraitCollection) -> UIStatusBarStyle {
        return chooseObject(traitCollection: traits,
                            light: UIStatusBarStyle.darkContent,
                            dark: UIStatusBarStyle.lightContent)
    }
    
    static func overridenUserInterfaceStyle(for traits: UITraitCollection) -> UIUserInterfaceStyle {
        return chooseObject(traitCollection: traits,
                            light: .light,
                            dark: .dark)
    }
    
    static let text = UIColor { traits in
        return chooseObject(traitCollection: traits,
                            light: UIColor(rgb: 0x161F28),
                            dark: UIColor(rgb: 0xFFFFFF))
    }
    
    static let button = UIColor { traits in
        return UIColor(rgb: 0x2B59C3)
    }
    
    private static func chooseObject<T>(traitCollection: UITraitCollection,
                                        light: T,
                                        dark: T) -> T {
        guard !forceLight else { return light }
        
        return traitCollection.userInterfaceStyle == .dark ? dark : light
    }
    
}

/// Stolen shamelessly from https://stackoverflow.com/a/35074069
extension UIColor {

    convenience init(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1.0)
    }

    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgb & 0x0000FF) / 255.0,
                  alpha: CGFloat(alpha))
    }
    
}
