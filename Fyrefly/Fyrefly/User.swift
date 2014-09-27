//
//  User.swift
//  Fyrefly
//
//  Created by Eric Appel on 9/26/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import Foundation

struct User {
    var name: String
    var coordinate: (x: Float, y: Float) = (-1, -1)
    
    init(name: String, json: [String : NSNumber]) {
        self.name = name
        coordinate.x = json["x"]!.floatValue
        coordinate.y = json["y"]!.floatValue
    }
}