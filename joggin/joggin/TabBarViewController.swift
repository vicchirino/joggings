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
        
        //Check if current User existme

        
        UITabBar.appearance().selectedImageTintColor = UIColor(red: 255/255, green: 171/255, blue: 22/255, alpha: 1)
        
        self.setNeedsStatusBarAppearanceUpdate()
                
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

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
