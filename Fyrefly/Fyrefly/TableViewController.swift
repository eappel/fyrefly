//
//  TableViewController.swift
//  Fyrefly
//
//  Created by Eric Appel on 9/26/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var usersArray: [User] =  [User]()
    var userLoginRefs: [Firebase] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("FYREFLY")
        
        let usersRef = Firebase(url: kFirebaseUsersPath)
        
        usersRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            var children = snapshot.children
            while let child: FDataSnapshot = children.nextObject() as? FDataSnapshot {
                let childName = child.name
                var childCoordinate: [String : NSNumber] = child.value["coordinate"] as [String : NSNumber]
                var childLoginStatus: NSNumber = child.value["isLoggedIn"] as NSNumber
                
                if childName != kCurrentUserID {
                    if NSNumber(bool: true) == childLoginStatus {
                        var newUser: User = User(name: childName, json: childCoordinate)
                        self.usersArray.append(newUser)
                        self.tableView(self.tableView, commitEditingStyle: .Insert, forRowAtIndexPath: NSIndexPath(forRow: self.usersArray.count-1, inSection: 0))
                    }
                    // create reference to isLoggedIn parameter for this user
                    var loginSnapshot: FDataSnapshot = child.childSnapshotForPath("isLoggedIn")
                    var childLoginRef = loginSnapshot.ref
                    self.userLoginRefs.append(childLoginRef)
                }
            }
            println(self.userLoginRefs)
        })
        
        for loginRef: Firebase in userLoginRefs {
            loginRef.observeEventType(.Value, withBlock: {
                snapshot in
                println(loginRef.parent.name)
                println(loginRef.name)
                println("here? \(snapshot.value)")
//                if snapshot.value as NSNumber == NSNumber(bool: true) {
//                    var newUser: User = User(name: childName, json: snapshot.value["coordinate"] as [String : NSNumber])
//                    self.usersArray.append(newUser)
//                    self.tableView(self.tableView, commitEditingStyle: .Insert, forRowAtIndexPath: NSIndexPath(forRow: self.usersArray.count-1, inSection: 0))
//                }
            })
        }

        usersRef.observeEventType(.ChildChanged, withBlock: {
            snapshot in
            if snapshot.value["isLoggedIn"] as NSNumber == NSNumber(bool: true) {
                if let childName = snapshot.name {
                    if childName != kCurrentUserID {
                        
                    }
                }
            } else if snapshot.value["isLoggedIn"] as NSNumber == NSNumber(bool: false) {
                if let childName = snapshot.name {
                    if childName != kCurrentUserID {
                        for i in 0..<self.usersArray.count {
                            if self.usersArray[i].name == childName {
                                self.usersArray.removeAtIndex(i)
                                self.tableView(self.tableView, commitEditingStyle: .Delete, forRowAtIndexPath: NSIndexPath(forRow: i, inSection: 0))
                            }
                        }
                    }
                }
            }
        })
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = usersArray[indexPath.row].name
        

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var drawingViewController = DrawingViewController(user: usersArray[indexPath.row])
        self.navigationController!.pushViewController(drawingViewController, animated: true)
    }


    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            var indexPaths: [NSIndexPath] = [indexPath]
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
