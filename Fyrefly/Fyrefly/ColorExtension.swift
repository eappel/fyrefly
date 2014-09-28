//
//  ColorExtension.swift
//  Fyrefly
//
//  Created by Eric Appel on 9/28/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import UIKit

extension UIColor {
    class func fyreflyOrange() -> UIColor {
//        return UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1)
        return UIColor(red: 1.0, green: 0.4, blue: 0.125, alpha: 1)
    }
    class func fyreflyBlue() -> UIColor {
        return UIColor(red: 0.31, green: 0.89, blue: 0.76, alpha: 1)
    }
    class func drawingGray() -> UIColor {
        return UIColor(red: 0.75, green: 0.75, blue: 0.60, alpha: 1)
    }
    class func drawingBlue() -> UIColor {
        return UIColor(red: 0.21, green: 0.65, blue: 0.44, alpha: 1)
    }
    class func indicatorOn() -> UIColor {
        return UIColor(red: 0.21, green: 0.38, blue: 0.02, alpha: 1)
    }
    class func indicatorOff() -> UIColor {
        return UIColor(red: 0.38, green: 0.02, blue: 0.02, alpha: 1)
    }
}
