//
//  DrawingViewController.swift
//  Fyrefly
//
//  Created by Eric Appel on 9/27/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {
    var friendName: String = ""
    let friendRef: Firebase = Firebase()
    let selfRef: Firebase = Firebase()
    
    var drawView = DrawingView(frame: UIScreen.mainScreen().bounds)
    
    
    init(user: User) {
        friendName = user.name
        friendRef = Firebase(url: kFirebaseUsersPath + friendName + "/coordinate")
        selfRef = Firebase(url: kFirebaseCurrentUserPath + "/coordinate")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        view = drawView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        friendRef.observeEventType(.Value, withBlock: {
            snapshot in
            println("observing")
            println(snapshot.value)
        })
    }
    
    
    
    
    func coordinateConstructor(touchPoint: CGPoint) -> [String : Float] {
        return [
            "x" : Float(touchPoint.x),
            "y" : Float(touchPoint.y)
        ]
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touchPoint: CGPoint = touches.anyObject()!.locationInView(view)
        selfRef.setValue(coordinateConstructor(touchPoint))
        drawView.path.moveToPoint(touchPoint)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var touchPoint: CGPoint = touches.anyObject()!.locationInView(view)
        selfRef.setValue(coordinateConstructor(touchPoint))
        drawView.path.addLineToPoint(touchPoint)
        drawView.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        var touchPoint: CGPoint = touches.anyObject()!.locationInView(view)
        selfRef.setValue(coordinateConstructor(touchPoint))
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        friendRef.removeAllObservers()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
