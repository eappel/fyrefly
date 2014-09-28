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
        if selfPoints.isEmpty && remotePoints.isEmpty { return }
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextFillRect(context, self.bounds)
        CGContextSetLineWidth(context, 5)
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineJoin(context, kCGLineJoinBevel)
        UIColor.drawingGray().setStroke()
        let scount = selfPoints.count == 0 ? UInt(selfPoints.count) : UInt(selfPoints.count-1)
        CGContextStrokeLineSegments(context, selfPoints, scount)
        UIColor.drawingBlue().setStroke()
        let rcount = remotePoints.count == 0 ? UInt(remotePoints.count) : UInt(remotePoints.count-1)
        CGContextStrokeLineSegments(context, remotePoints, rcount)
        CGContextRestoreGState(context)
    }
    
}
