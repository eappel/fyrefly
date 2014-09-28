//
//  DrawingViewController.swift
//  Fyrefly
//
//  Created by Eric Appel on 9/27/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {
    let remoteRef: Firebase = Firebase()
    let selfRef: Firebase = Firebase()
    var touchesBegan: Bool = false
    var touchesEnded: Bool = false
    var setup: Bool = true
    
    var drawView = DrawingView(frame: UIScreen.mainScreen().bounds)
    
    var selfTimer: NSTimer!
    var remoteTimer: NSTimer!
    
    var selfMetaTimer: NSTimer!
    var remoteMetaTimer: NSTimer!
    
    var removingSelfPoints: Bool = false
    var removingRemotePoints: Bool = false
    
    var selfMetaTimerActive: Bool = false
    var remoteMetaTimerActive: Bool = false

    
    init(user: User) {
        remoteRef = Firebase(url: kFirebaseUsersPath + user.name + "/coordinate")
        selfRef = Firebase(url: kFirebaseCurrentUserPath + "/coordinate")
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
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
        
        remoteRef.observeEventType(.Value, withBlock: {
            snapshot in
            self.handleRemoteCoordinate(snapshot.value as [String : Float])
        })
        
        
        
        selfTimer = NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: "handleTimer:", userInfo: nil, repeats: true)
        remoteTimer = NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: "handleTimer:", userInfo: nil, repeats: true)
        
        selfMetaTimer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "handleMetaTimer:", userInfo: nil, repeats: true)
        remoteMetaTimer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "handleMetaTimer:", userInfo: nil, repeats: true)

    }
    
    func handleTimer(sender: NSTimer) {
        println("regtimer")
        if sender == selfTimer && removingSelfPoints {
            if drawView.selfPoints.count >= 2 {
                drawView.selfPoints.removeLastLineSegment()
                drawView.setNeedsDisplay()
            } else {
                selfMetaTimerActive = false
                removingSelfPoints = false
            }
            return
        }
        if sender == remoteTimer && removingRemotePoints {
            if drawView.remotePoints.count >= 2 {
                drawView.remotePoints.removeLastLineSegment()
                drawView.setNeedsDisplay()
            } else {
                remoteMetaTimerActive = false
                removingRemotePoints = false
            }
            return
        }

    }
    
    func handleMetaTimer(sender: NSTimer) {
        if sender == selfMetaTimer {
            if selfMetaTimerActive {
                removingSelfPoints = true
            } else {
                removingSelfPoints = false
            }
        }
        if sender == remoteMetaTimer {
            if remoteMetaTimerActive {
                removingRemotePoints = true
            } else {
                removingRemotePoints = false
            }
        }
    }
    
    func handleRemoteCoordinate(coordinate: [String : Float]) {
        if setup {
            setup = false
            return
        }
        if coordinate["x"]! == -2.0 {
            println("BEGAN")
            drawView.setNeedsDisplay()
            touchesBegan = true
            return
        }
        if coordinate["x"] == -1.0 {
            println("ENDED")
            touchesEnded = true
            return
        }
        
        if touchesBegan {
            println("BEGAN")
            drawView.remotePoints.addStartingPoint(touchPointConstructor(coordinate))
            remoteMetaTimerActive = false
            removingRemotePoints = false
            touchesBegan = false
            return
        }
        if touchesEnded {
            println("ENDED")
            drawView.remotePoints.addEndPoint(touchPointConstructor(coordinate))
            drawView.setNeedsDisplay()
            remoteMetaTimerActive = true
            touchesEnded = false
            return
        }
        
        drawView.remotePoints.addMoveToPoint(touchPointConstructor(coordinate))
        drawView.setNeedsDisplay()
        remoteMetaTimerActive = false
        removingRemotePoints = false
        
        println("moved")
        
    }
    
    func coordinateConstructor(touchPoint: CGPoint) -> [String : Float] {
        return [
            "x" : Float(touchPoint.x),
            "y" : Float(touchPoint.y)
        ]
    }
    
    func touchPointConstructor(coordinate: [String : Float]) -> CGPoint {
        return CGPoint(
            x: CGFloat(coordinate["x"]!),
            y: CGFloat(coordinate["y"]!)
        )
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touchPoint: CGPoint = touches.anyObject()!.locationInView(view)
        selfRef.setValue(coordinateConstructor(CGPoint(x: -2.0, y: -2.0)))
        selfRef.setValue(coordinateConstructor(touchPoint))
        drawView.selfPoints.addStartingPoint(touchPoint)
        selfMetaTimerActive = false
        removingSelfPoints = false
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touchPoint: CGPoint = touches.anyObject()!.locationInView(view)
        selfRef.setValue(coordinateConstructor(touchPoint))
        drawView.selfPoints.addMoveToPoint(touchPoint)
        drawView.setNeedsDisplay()
        selfMetaTimerActive = false
        removingSelfPoints = false
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touchPoint: CGPoint = touches.anyObject()!.locationInView(view)
        drawView.selfPoints.addEndPoint(touchPoint)
        drawView.setNeedsDisplay()
        
        selfRef.setValue(coordinateConstructor(CGPoint(x: -1.0, y: -1.0)))
        selfRef.setValue(coordinateConstructor(touchPoint))
        
        selfMetaTimerActive = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        remoteRef.removeAllObservers()
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
