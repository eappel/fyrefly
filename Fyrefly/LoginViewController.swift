//
//  LoginViewController.swift
//  Fyrefly
//
//  Created by Eric Appel on 9/28/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    var takenUsernames: [String] = []
    var tableViewController: TableViewController?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("view did load")
        usernameTextField.becomeFirstResponder()
        usernameTextField.delegate = self
        
        usernameTextField.autocapitalizationType = UITextAutocapitalizationType.None
        usernameTextField.autocorrectionType = UITextAutocorrectionType.No

        // Do any additional setup after loading the view.
    }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if contains(takenUsernames, textField.text) {
            textField.text = ""
            warningLabel.text = "That username is taken"
            return false
        } else {
            // create and save to user defaults
            NSUserDefaults.standardUserDefaults().setObject(textField.text, forKey: "username")
            NSUserDefaults.standardUserDefaults().synchronize()
            kCurrentUserID = textField.text
            var userRef = Firebase(url: kFirebaseCurrentUserPath)
            addUserToFirebase(userRef)
            dismissViewControllerAnimated(true, completion: {})
            tableViewController?.setupEnvironment()
            return true
        }
    }
    
    func addUserToFirebase(ref: Firebase) {
        ref.childByAppendingPath("chattingWith").setValue("")
        ref.childByAppendingPath("coordinate").setValue([
            "x" : NSNumber(float: 0),
            "y" : NSNumber(float: 0)
            ]
        )
        ref.childByAppendingPath("isLoggedIn").setValue(NSNumber(bool: true))
    }
    
    @IBAction func usernameTextfieldEditingChanged(sender: UITextField) {
        warningLabel.text = ""
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
