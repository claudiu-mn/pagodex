//
//  ViewUtilities.swift
//  Pagodex
//
//  Created by Claudiu Miron on 22.10.2023.
//

import UIKit

extension UIView {
    /// The view that calls this method must be a subview of the view to be filled.
    func fill(_ aView: UIView, with insets: UIEdgeInsets = .zero) {
        leadingAnchor.constraint(equalTo: aView.leadingAnchor,
                                 constant: insets.left).isActive = true
        trailingAnchor.constraint(equalTo: aView.trailingAnchor,
                                  constant: -insets.right).isActive = true
        topAnchor.constraint(equalTo: aView.topAnchor,
                             constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: aView.bottomAnchor,
                                constant: -insets.bottom).isActive = true
    }
}
