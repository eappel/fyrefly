//
//  Constants.swift
//  Fyrefly
//
//  Created by Eric Appel on 9/26/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import Foundation

let kFirebaseURL: String = "https://fyrefly.firebaseio.com"
let kFirebaseDataPath: String = kFirebaseURL + "/app"
let kFirebaseUsersPath: String = kFirebaseDataPath + "/users/"
let kFirebaseCurrentUserPath: String = kFirebaseUsersPath + kCurrentUserID

//let kCurrentUserID: String = "eric"
let kCurrentUserID: String = "peter"

let kCurrentUserRef = Firebase(url: kFirebaseCurrentUserPath)
