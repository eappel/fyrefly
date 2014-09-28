//
//  PointArrayExtension.swift
//  Fyrefly
//
//  Created by Lucas Derraugh on 9/27/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import UIKit

extension Array {
    mutating func addStartingPoint(point: CGPoint) {
        self.append(point as T)
    }
    
    mutating func addMoveToPoint(point: CGPoint) {
        self.append(point as T)
        self.append(point as T)
    }
    
    mutating func addEndPoint(point: CGPoint) {
        self.append(point as T)
    }
    
    mutating func removeLastLineSegment() {
        if self.count >= 2 {
            self.removeRange(0...1)
        }
    }
}
