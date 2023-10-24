//
//  ChevronView.swift
//  Pagodex
//
//  Created by Claudiu Miron on 22.10.2023.
//

import UIKit

class ChevronView: UIView {
    
    override func draw(_ rect: CGRect) {
        tintColor.setStroke()
        
        let lineWidth = 2.0
        
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
