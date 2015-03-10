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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
