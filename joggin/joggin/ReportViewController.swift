//
//  ReportViewController.swift
//  joggin
//
//  Created by Victor Gabriel Chirino on 3/9/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username.text = PFUser.currentUser().username

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.report()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Logout(sender: AnyObject) {

       
        PFUser.logOut()
        var currentUser = PFUser.currentUser()

        let tabBarController = self.tabBarController as TabBarViewController
        
        var storyboard = UIStoryboard(name: "login", bundle: nil)
        var controller = storyboard.instantiateViewControllerWithIdentifier("InitialViewController") as LoginViewController
        controller.delegate = tabBarController
        self.presentViewController(controller, animated: true, completion:{finished in
            tabBarController.selectedIndex = 0
        })

    }
    
    func report(){
        
        PZUILoader.sharedLoader().show()
        
        var distanceOkWeek:Float!
        var cantOfJoggings:Float!
        var averageSpeed:Float!
        var velocityKmH:Float!
        
        cantOfJoggings = 0.0
        velocityKmH = 0.0
        averageSpeed = 0.0
        distanceOkWeek = 0.0

        var today = NSDate()
        var gregorian = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        
        var weekdayComponents: NSDateComponents = gregorian?.components(NSCalendarUnit.WeekdayCalendarUnit, fromDate: today) as NSDateComponents!

        var componentsToSubstract = NSDateComponents()
        componentsToSubstract.day = 0 - (weekdayComponents.weekday + 5)
        
        var beginningOfWeek = gregorian?.dateByAddingComponents(componentsToSubstract, toDate: today, options: NSCalendarOptions.allZeros)
    

        componentsToSubstract.day = 0 - (weekdayComponents.weekday - 2)
        var endOfTheWeek = gregorian?.dateByAddingComponents(componentsToSubstract, toDate: today, options: NSCalendarOptions.allZeros)
        
        var query = PFQuery(className:"Jogging")
        query.whereKey("userID", equalTo: PFUser.currentUser())
        query.whereKey("date", greaterThanOrEqualTo: beginningOfWeek)
        query.whereKey("date", lessThanOrEqualTo: endOfTheWeek)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            PZUILoader.sharedLoader().hide()
            
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                for object in objects {
                    cantOfJoggings = cantOfJoggings + 1
                    NSLog("%@", object.objectId)
                    let jogging: Jogging = object as Jogging
                    distanceOkWeek = distanceOkWeek + jogging.distanceKm.floatValue
                    var hours:Float = jogging.minutes.floatValue/60
                    velocityKmH = velocityKmH + (jogging.distanceKm.floatValue / hours)
                }
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
                
            }
            
            averageSpeed = velocityKmH / cantOfJoggings
            
            self.speedLabel.text = NSString(format: "%.1f km/h", averageSpeed)
            self.distanceLabel.text = NSString(format: "%.1f km", distanceOkWeek)
        }
        
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
