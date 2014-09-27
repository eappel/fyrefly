//
//  User.swift
//  Fyrefly
//
//  Created by Eric Appel on 9/26/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import Foundation

struct User {
    var coordinate: (x: Float, y: Float) = (-1, -1)
    
    init(json: [String : NSNumber]) {
        coordinate.x = json["x"]!
        coordinate.y = json["y"]!
        println("\(coordinate)")
    }
}