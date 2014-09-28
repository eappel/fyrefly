//
//  TableViewController.swift
//  Fyrefly
//
//  Created by Eric Appel on 9/26/14.
//  Copyright (c) 2014 Eric Appel. All rights reserved.
//

import UIKit

protocol LoginStatusDelegate {
    func userDidGoOffline(name: String)
    func userDidComeOnline(name: String)
}

class TableViewController: UITableViewController {
    var usersArray: [User] =  [User]()
    
    @IBOutlet var tableViewHeader: UIView!
    @IBOutlet weak var onlineFriendsLabel: UILabel!
    
    var fyreSpace: LoginStatusDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("FYREFLY")
        
//        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundTile"))
        
        tableView.alwaysBounceVertical = false
        
        NSBundle.mainBundle().loadNibNamed("TableViewHeader", owner: self, options: nil)
        tableView.tableHeaderView = tableViewHeader
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
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
                        println("login event")
                        self.addUserFromRef(parentRef)
                        self.fyreSpace?.userDidComeOnline(parentRef.name)
                    } else if snapshot.value as NSNumber == NSNumber(bool: false) {
                        println("login event")
                        for i in 0..<self.usersArray.count {
                            if self.usersArray[i].name == parentRef.name {
                                self.fyreSpace?.userDidGoOffline(parentRef.name)
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
            let userCoordinate: [String : NSNumber] = snapshot.value["coordinate"] as [String : NSNumber]
            var newUser = User(name: userName, json: userCoordinate)
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
//        return 5
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        var separator: UIView = UIView(frame: CGRect(x: 0, y: cell.contentView.frame.height - 3, width: cell.contentView.frame.width, height: 3))
        separator.backgroundColor = UIColor.fyreflyOrange()
        cell.contentView.addSubview(separator)
        
        var titleLabel: UILabel = UILabel(frame: CGRect(x: 15, y: 0, width: cell.contentView.frame.width - 15, height: cell.contentView.frame.height - 7))
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 36.0)
//        titleLabel.text = "Eric Appel"
        titleLabel.text = usersArray[indexPath.row].name.uppercaseString
        titleLabel.textColor = UIColor.fyreflyOrange()
        cell.contentView.addSubview(titleLabel)
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var drawingViewController = DrawingViewController(user: User(name: "peter", json: [
//            "x" : 50,
//            "y" : 50
//            ]))
        var selectedUser: User = usersArray[indexPath.row]
        var drawingViewController = DrawingViewController(user: selectedUser)
        kCurrentUserRef.childByAppendingPath("chattingWith").setValue(selectedUser.name)
        fyreSpace = drawingViewController
        self.navigationController!.pushViewController(drawingViewController, animated: true)
    }


    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        onlineFriendsLabel.text? = "\(usersArray.count)"
        if editingStyle == .Delete {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
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
