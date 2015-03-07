//
//  AddJoggingTableViewController.swift
//  joggin
//
//  Created by Victor Chirino on 3/6/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

let reuseIdentifier = "EntryCell"

class AddJoggingTableViewController: UITableViewController {

    var customPickerView:CustomPickerView!
    var jogging: Jogging! {
        didSet {
            self.distanceKm = jogging.distanceKm
            self.minutes = NSString(format: "%d", jogging.minutes.integerValue)
            var dateFormatter = NSDateFormatter()
            self.date = dateFormatter.stringFromDate(jogging.date)
            self.tableView.reloadData()
        }
    }
    var footerView: UIView!
    var distanceKm: NSString!
    var date: NSString!
    var minutes: NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.customPickerView = CustomPickerView(frame: CGRectMake(0, 0, self.view.bounds.width, 260))
        self.customPickerView.backgroundColor = UIColor.whiteColor()
        self.customPickerView.userInteractionEnabled = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"pressDoneButton:", name: kNotificationDoneButtonPicker, object: nil);
        
        self.distanceKm = ""
        self.date = ""
        self.minutes = ""
        
        self.footerView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 300))
        self.footerView.backgroundColor = UIColor.whiteColor()
        
        var addEntryButton = UIButton()
        addEntryButton.setTitle("Add new jogging", forState: UIControlState.Normal)
        addEntryButton.setTitleColor(UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0), forState: UIControlState.Normal)
        addEntryButton.addTarget(self, action: "addPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        addEntryButton.frame = self.footerView.frame
        addEntryButton.center = self.footerView.center
        self.footerView.addSubview(addEntryButton)
        
        self.tableView.tableFooterView = self.footerView
    }
    
//    func setJogging(jogging: Jogging!){
//        self.distanceKm = jogging.distanceKm
//        self.minutes = NSString(format: "%d", jogging.minutes.integerValue)
//        var dateFormatter = NSDateFormatter()
//        self.date = dateFormatter.stringFromDate(jogging.date)
//        self.tableView.reloadData()
//    }
    
    func setDistance(distance: NSString, timeSpent:NSNumber, inDate:NSDate){

    }

    func addPressed(sender: UIButton){
        NSLog("CREAR JOGGING")
        
        var newTextEntry = NSMutableArray()

        if (checkParameters()){
            for index in 0...2 {
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as EntryTableViewCell
                newTextEntry.addObject(cell.infoTextField.text)
            }
            (self.jogging != nil) ? self.editJogging(newTextEntry) : self.addJogging(newTextEntry)
            
        }else{
            self.createAlert("Oops we encountered an error", message: "All of the fields must be filled")
        }
        
    }
    
    func addJogging(array: NSArray) {
        
        PZUILoader.sharedLoader().show()
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        self.jogging = Jogging()

        self.jogging.distanceKm = array[0] as NSString
        self.jogging.minutes = NSNumber(integer: array[1].integerValue)
        self.jogging.date = dateFormatter.dateFromString(array[2] as NSString)
        self.jogging.userID = PFUser.currentUser()
        
        self.jogging.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            
            PZUILoader.sharedLoader().hide()
            
            if (success) {
                var user = PFUser.currentUser()
                var relation = user.relationForKey("joggings")
                
                relation.addObject(self.jogging)
                
                user.saveInBackgroundWithBlock {(success: Bool, error: NSError!) -> Void in}
                var homeViewController = self.navigationController?.viewControllers[0] as HomeTableViewController
                homeViewController.joggingsArray.addObject(self.jogging)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                var info = error.userInfo!
                let errorString = info["error"] as NSString
                self.createAlert("Error", message: errorString)
            }
        }
    }
    
    func editJogging(array: NSArray){
        
        PZUILoader.sharedLoader().show()
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        self.jogging.distanceKm = array[0] as NSString
        self.jogging.minutes = NSNumber(integer: array[1].integerValue)
        self.jogging.date = dateFormatter.dateFromString(array[2] as NSString)
        
        self.jogging.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                var homeViewController = self.navigationController?.viewControllers[0] as HomeTableViewController
                var array = homeViewController.joggingsArray
                
                for joggingToReplace in array{
                    if joggingToReplace.objectId == self.jogging.objectId{
                        homeViewController.joggingsArray.removeObject(joggingToReplace)
                        homeViewController.joggingsArray.addObject(self.jogging)
                    }
                }
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                var info = error.userInfo!
                let errorString = info["error"] as NSString
                self.createAlert("Error", message: errorString)
            }
            PZUILoader.sharedLoader().hide()
        }
    }
    
    func createAlert(title: NSString, message: NSString) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func checkParameters() -> Bool
    {
        
        let cell0 = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as EntryTableViewCell
        let cell1 = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as EntryTableViewCell
        let cell2 = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as EntryTableViewCell
        
        var textfieldArray = [cell0.infoTextField.text, cell1.infoTextField.text,cell2.infoTextField.text]
        for text in textfieldArray {
            if text as NSString == "" {
                return false
            }
        }
        return true
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
        return 3
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? EntryTableViewCell
        if cell == nil {
            cell = EntryTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        if indexPath.row == 0 {
            cell?.infoLabel.text = "Distance in Km:"
            cell?.infoTextField.placeholder = "Km"
            if self.jogging != nil {
                cell?.infoTextField.text = self.jogging.distanceKm
            }
            
        }
        if indexPath.row == 1 {
            cell?.infoLabel.text = "Time in Minutes:"
            cell?.infoTextField.placeholder = "Minutes"
            if self.jogging != nil {
                cell?.infoTextField.text = NSString(format: "%d", self.jogging.minutes.integerValue)
            }
        }
        if indexPath.row == 2 {
            cell?.infoLabel.text = "Date:"
            cell?.infoTextField.placeholder = "Date"
            if self.jogging != nil {
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy"
                cell?.infoTextField.text = dateFormatter.stringFromDate(self.jogging.date)
            }
            cell?.infoTextField.inputView = self.customPickerView
        }
        // Configure the cell...

        return cell!
    }

    func pressDoneButton(notification:NSNotification){
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as EntryTableViewCell
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        var date = notification.object as NSDate
        var string =  dateFormatter.stringFromDate(date)
        //LOCALE TIMEZONE
        cell.infoTextField.text = string
        cell.infoTextField.resignFirstResponder()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
