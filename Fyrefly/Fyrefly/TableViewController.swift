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

    override func viewDidLoad() {
        super.viewDidLoad()
                
        println("FYREFLY")
        
        let usersRef = Firebase(url: kFirebaseUsersPath)
        
        usersRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            var userLoginRefs: [Firebase] = []
            var children = snapshot.children
            while let child: FDataSnapshot = children.nextObject() as? FDataSnapshot {
                let childName = child.name
                let childCoordinate: [String : NSNumber] = child.value["coordinate"] as [String : NSNumber]
                let loginSnapshot: FDataSnapshot = child.childSnapshotForPath("isLoggedIn")
                if childName != kCurrentUserID {
                    // create reference to isLoggedIn parameter for this user
                    var childLoginRef = loginSnapshot.ref
                    userLoginRefs.append(childLoginRef)
                }
            }
            
            // add observers for the isLoggedIn flag for every other user
            for loginRef: Firebase in userLoginRefs {
                loginRef.observeEventType(.Value, withBlock: {
                    snapshot in
                    let parentRef = loginRef.parent
                    if snapshot.value as NSNumber == NSNumber(bool: true) {
                        self.addUserFromRef(parentRef)
                    } else if snapshot.value as NSNumber == NSNumber(bool: false) {
                        for i in 0..<self.usersArray.count {
                            if self.usersArray[i].name == parentRef.name {
                                self.usersArray.removeAtIndex(i)
                                self.tableView(self.tableView, commitEditingStyle: .Delete, forRowAtIndexPath: NSIndexPath(forRow: i, inSection: 0))
                            }
                        }
                    }
                })
            }
        })
    }

    func addUserFromRef(ref: Firebase) {
        ref.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let userName = ref.name
            println("username" + userName)
            let userCoordinate: [String : NSNumber] = snapshot.value["coordinate"] as [String : NSNumber]
            var newUser = User(name: userName, json: userCoordinate)
            println(newUser.name)
            self.usersArray.append(newUser)
            self.tableView(self.tableView, commitEditingStyle: .Insert, forRowAtIndexPath: NSIndexPath(forRow: self.usersArray.count-1, inSection: 0))
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
