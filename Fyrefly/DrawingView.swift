//
//  DrawingView.swift
//  Fyrefly
//
//  Created by Eric Appel on 9/27/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import UIKit

class DrawingView: UIView {
    var selfPoints: [CGPoint] = []
    var remotePoints: [CGPoint] = []
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        if selfPoints.count > 0 {
            selfPoints.append(selfPoints.last!)
        }
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, self.bounds)
        UIColor.blackColor().setStroke()
        CGContextStrokeLineSegments(context, selfPoints, UInt(selfPoints.count))
        if selfPoints.count > 0 {
            selfPoints.removeLast()
        }
        CGContextRestoreGState(context)
    }
}
