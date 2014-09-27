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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        println("FYREFLY")
        
        //  Create reference to Firebase location
        
        var coordinateDictionary: [String : NSNumber] = [
            "x" : NSNumber(float: 100.1),
            "y" : NSNumber(float: 205.5)
        ]
        
        
        
        //  Read data and react to changes
//        currentUserRef.observeEventType(.Value, withBlock: {
//            snapshot in
//            println("\(snapshot.name) -> \(snapshot.value)")
//        })
        
        let userRef = Firebase(url: kFirebaseUsersPath)
        
        userRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            var children = snapshot.children
            while let child = children.nextObject() as? FDataSnapshot {
                if let childName = child.value["name"] as? String {
                    println("\(childName)")
                    var newUser: User = User(json: child.value["coordinate"] as [String : NSNumber])
                    self.usersArray.append(newUser)
//                    println("\(newUser.coordinate)")
                }
            }
        
//            println("snapshot value: \n\(snapshot.value)")
        })

        userRef.observeEventType(.ChildChanged, withBlock: {
            snapshot in
            println(snapshot.value)
        })
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
