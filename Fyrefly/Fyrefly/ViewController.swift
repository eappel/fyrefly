//
//  ViewController.swift
//  Fyrefly
//
//  Created by Eric Appel on 9/26/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("FYREFLY")
        
        //  Create reference to Firebase location
        var myRootRef = Firebase(url: kFirebaseURL)
        //  Write data to Firebase
        myRootRef.setValue("FIREBASE DATA!!!")
        
        //  Read data and react to changes
        myRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            println("\(snapshot.name) -> \(snapshot.value)")
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

