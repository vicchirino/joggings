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
    var jogging: Jogging!
    var footerView: UIView!
    
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

    func addPressed(sender: UIButton){
        NSLog("CREAR JOGGING")
        
        if (checkParameters()){
            //CREO UN NUEVO JOGGIN
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            self.createAlert("Oops we encountered an error", message: "All of the fields must be filled")
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
//        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as EntryTableViewCell
        
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? EntryTableViewCell
        if cell == nil {
            cell = EntryTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        if indexPath.row == 0 {
            cell?.infoLabel.text = "Distance in Km:"
            cell?.infoTextField.placeholder = "Km"
        }
        if indexPath.row == 1 {
            cell?.infoLabel.text = "Time in Minutes:"
            cell?.infoTextField.placeholder = "Minutes"
        }
        if indexPath.row == 2 {
            cell?.infoLabel.text = "Date:"
            cell?.infoTextField.placeholder = "Date"
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
