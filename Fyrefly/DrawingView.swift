//
//  DrawingView.swift
//  Fyrefly
//
//  Created by Eric Appel on 9/27/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import UIKit

class DrawingView: UIView {
    
    var path: UIBezierPath = UIBezierPath()
    
    override func drawRect(rect: CGRect) {
        UIColor.blackColor().setStroke()
        path.lineWidth = 3.0
        path.stroke()
    }
    
}
