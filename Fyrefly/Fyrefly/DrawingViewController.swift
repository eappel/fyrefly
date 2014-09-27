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
    
    var timer: NSTimer!
    
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
        
        selfRef.observeEventType(.Value, withBlock: {
            snapshot in
            println("observing")
            println(snapshot.value)
            self.handleRemoteCoordinate(snapshot.value as [String : Float])
        })
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "handleTimer", userInfo: nil, repeats: true)
    }
    
    func handleTimer() {
        if drawView.selfPoints.count > 2 {
            drawView.selfPoints.removeRange(0...1)
            drawView.setNeedsDisplay()
        }
    }
    
    
    func handleRemoteCoordinate(coordinate: [String : Float]) {
        drawRemotePoint(
            CGPoint(
            x: CGFloat(coordinate["x"]!),
            y: CGFloat(coordinate["y"]!)
            )
        )
    }
    
    func drawRemotePoint(touchPoint: CGPoint) {
        
    }
    
    
    func coordinateConstructor(touchPoint: CGPoint) -> [String : Float] {
        return [
            "x" : Float(touchPoint.x),
            "y" : Float(touchPoint.y)
        ]
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touchPoint: CGPoint = touches.anyObject()!.locationInView(view)
        selfRef.setValue(coordinateConstructor(touchPoint))
        drawView.selfPoints.append(touchPoint)
        println("\(drawView.selfPoints)")
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touchPoint: CGPoint = touches.anyObject()!.locationInView(view)
        selfRef.setValue(coordinateConstructor(touchPoint))
        drawView.selfPoints.append(touchPoint)
        drawView.selfPoints.append(touchPoint)
        drawView.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touchPoint: CGPoint = touches.anyObject()!.locationInView(view)
        selfRef.setValue(coordinateConstructor(touchPoint))
        drawView.selfPoints.append(touchPoint)
//        drawView.setNeedsDisplay()
        timer.fire()
        
        kCurrentUserRef.childByAppendingPath("touchesEnded").setValue(NSNumber(bool: true), withCompletionBlock: {
            (error, fbase) -> Void in
            fbase.childByAppendingPath("touchesEnded").setValue(NSNumber(bool: false))
        })
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
