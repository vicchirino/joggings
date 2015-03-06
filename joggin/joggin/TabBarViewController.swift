//
//  TabBarViewController.swift
//  joggin
//
//  Created by Victor Chirino on 3/5/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController,LoginViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Check if current User exist
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            
        } else {
            var storyboard = UIStoryboard(name: "login", bundle: nil)
            var controller = storyboard.instantiateViewControllerWithIdentifier("InitialViewController") as LoginViewController
            controller.delegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Mark LoginViewControllerDelegate
    
    func startApplicationWithUser(user: PFUser){
        NSLog("ENTRO EN LA APLICACIÓN")
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationFetchInformation, object: nil);
    }

}
