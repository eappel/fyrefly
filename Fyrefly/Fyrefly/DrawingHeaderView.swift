//
//  DrawingHeaderView.swift
//  Fyrefly
//
//  Created by Eric Appel on 9/28/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import UIKit

protocol BackButtonDelegate {
    func backbuttonPressed()
}

class DrawingHeaderView: UIView {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var viewIndicator: UIView!
    
    var delegate: BackButtonDelegate?
    
    func setText(text: String) {
        textLabel.text = text
    }
    
    class func headerView() -> DrawingHeaderView {
        var headerView: DrawingHeaderView = NSBundle.mainBundle().loadNibNamed("DrawingHeaderView", owner: nil, options: nil).first as DrawingHeaderView
        return headerView
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        delegate?.backbuttonPressed()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
