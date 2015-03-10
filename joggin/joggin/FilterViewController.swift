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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
