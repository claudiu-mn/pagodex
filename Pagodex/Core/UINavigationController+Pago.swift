//
//  UINavigationController+Pago.swift
//  Pagodex
//
//  Created by Claudiu Miron on 23.10.2023.
//

import UIKit

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = Colors.backgroundPrimary
        standardAppearance.largeTitleTextAttributes = [.foregroundColor: Colors.text]
        standardAppearance.titleTextAttributes = [.foregroundColor: Colors.text]

        let compactAppearance = standardAppearance.copy()
        
        let navBar = navigationBar
        navBar.overrideUserInterfaceStyle = Colors.overridenUserInterfaceStyle(for: traitCollection)
        navBar.prefersLargeTitles = true
        navBar.standardAppearance = standardAppearance
        navBar.scrollEdgeAppearance = standardAppearance
        navBar.compactAppearance = compactAppearance
        navBar.layoutMargins.left = 24
        if #available(iOS 15.0, *) {
            navBar.compactScrollEdgeAppearance = compactAppearance
        }
    }
}
