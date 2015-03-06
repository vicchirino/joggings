//
//  HomeTableViewController.swift
//  joggin
//
//  Created by Victor Chirino on 3/5/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var user :PFUser!
    var joggingsArray :NSMutableArray!
    var emptyStateView: EmptyStateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.joggingsArray = NSMutableArray()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"fetchInformation", name: kNotificationFetchInformation, object: nil);

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.registerNib(UINib(nibName:"HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        
        self.user = PFUser.currentUser()
        
        if (user != nil){
            self.title = user.username
            self.getUserJogging()
        }else{
            NSLog("No hay usuario")
        }
        
    }
    
    func fetchInformation(){
        self.user = PFUser.currentUser()
        self.title = user.username
        self.getUserJogging()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    func getUserJogging() {
        
        var query = PFQuery(className:"Jogging")
        query.whereKey("userID", equalTo: PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
//            self.activityIndicator.stopAnimating()
            
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                for object in objects {
                    NSLog("%@", object.objectId)
                    let jogging: Jogging = object as Jogging
                    self.joggingsArray.addObject(jogging)
                }
                self.joggingsArray.count > 0 ? self.tableView.reloadData() : self.addEmptyState()
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
                
            }
        }
    }
    func addEmptyState(){        
        self.emptyStateView = EmptyStateView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height))
        self.emptyStateView.alpha = 0.0
        self.tableView.addSubview(self.emptyStateView)
        UIView.animateWithDuration(0.5, delay: 0.0, options: nil, animations: {
            self.emptyStateView.alpha = 1.0
            }, completion: nil)
    }
    func removeEmptyStateView(){
        if self.emptyStateView != nil {
            self.emptyStateView.removeFromSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.joggingsArray.count
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            NSLog("BORRA")
            var jogging = self.joggingsArray[indexPath.row] as Jogging
            self.joggingsArray.removeObject(jogging)
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.endUpdates()
            jogging.deleteInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                }
            }
            self.joggingsArray.count > 0 ? self.removeEmptyStateView() : self.addEmptyState()

        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as HomeTableViewCell

        // Configure the cell...
        
        let jogging = self.joggingsArray[indexPath.row] as Jogging
        
        cell.setDistance(jogging.distanceKm)
        cell.setDate(jogging.date)
        cell.setTime(jogging.minutes)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70;
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "addJoggingSegue" {
            let destinationVC = segue.destinationViewController as AddJoggingTableViewController
        }
    }

}
