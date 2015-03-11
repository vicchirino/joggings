//
//  FilterViewController.swift
//  joggin
//
//  Created by Victor Chirino on 3/10/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, CalendarDelegate {

    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    var filtredArray :NSMutableArray!

    
    var fromDate: NSDate!
    var toDate: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filtredArray = NSMutableArray()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK - CalendarViewDelegate
    
    func tapFromDate(fromDate: NSDate!, toDate: NSDate!) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        self.fromDateLabel.text = dateFormatter.stringFromDate(fromDate)
        self.toDateLabel.text = dateFormatter.stringFromDate(toDate)
    }
    
    func tappedDeleteDates() {
        self.fromDateLabel.text = "Date"
        self.toDateLabel.text = "Date"
    }
    
    func didChangeStartDate(startDate: NSDate!, andEndDate endDate: NSDate!) {
        if startDate != nil || endDate != nil {
            self.fromDate = startDate
            self.toDate = endDate
            self.filtreJoggings()
            PZUILoader.sharedLoader().show()
        }
    }
    
    
    func filtreJoggings(){
        
        self.filtredArray.removeAllObjects()
        
        var query = PFQuery(className:"Jogging")
        query.whereKey("userID", equalTo: PFUser.currentUser())
        query.whereKey("date", greaterThanOrEqualTo: self.fromDate)
        query.whereKey("date", lessThanOrEqualTo: self.toDate)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            PZUILoader.sharedLoader().hide()
            
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                for object in objects {
                    NSLog("%@", object.objectId)
                    let jogging: Jogging = object as Jogging
                    self.filtredArray.addObject(jogging)
                }
                self.performSegueWithIdentifier("filtredSegue", sender: self)
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
                
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "filtredSegue" {
            let destinationVC: ResultsTableViewController = segue.destinationViewController as ResultsTableViewController
            destinationVC.joggingsArray = self.filtredArray

        }
    }

}
