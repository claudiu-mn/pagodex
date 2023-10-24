//
//  UIView+Pago.swift
//  Pagodex
//
//  Created by Claudiu Miron on 22.10.2023.
//

import UIKit

extension UIView {
    
    /// The view that calls this method must be a subview of the view to be filled.
    internal func fill(_ aView: UIView, with insets: UIEdgeInsets = .zero) {
        leadingAnchor.constraint(equalTo: aView.leadingAnchor,
                                 constant: insets.left).isActive = true
        trailingAnchor.constraint(equalTo: aView.trailingAnchor,
                                  constant: -insets.right).isActive = true
        topAnchor.constraint(equalTo: aView.topAnchor,
                             constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: aView.bottomAnchor,
                                constant: -insets.bottom).isActive = true
    }
    
    /// Draws a right-pointing chevron.
    internal func drawChevron(in rect: CGRect,
                              lineWidth: CGFloat = 2,
                              color: UIColor = .tintColor) {
        color.setStroke()
        
        // TODO: Why does this give (inf, inf, 0, 0) with lineWidth = 5
        //       within (0, 0, 9, 16) bounds?
        // let pointRect = bounds.insetBy(dx: lineWidth, dy: lineWidth)
        
        let pointRect = CGRect(x: lineWidth / 2,
                               y: lineWidth / 2,
                               width: bounds.width - lineWidth,
                               height: bounds.height - lineWidth)
        
        let path = UIBezierPath()
        path.move(to: pointRect.origin)
        path.addLine(to: CGPoint(x: pointRect.maxX,
                                 y: pointRect.midY))
        path.addLine(to: CGPoint(x: pointRect.minX,
                                 y: pointRect.maxY))
        path.lineCapStyle = .round
        path.lineJoinStyle = .round // TODO: Tip of chevron needs to be sharp
        path.lineWidth = lineWidth
        path.stroke()
    }
    
}
