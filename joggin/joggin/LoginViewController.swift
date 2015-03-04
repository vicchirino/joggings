//
//  LoginViewController.swift
//  joggin
//
//  Created by Victor Chirino on 3/4/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var containerViewController: InfoLoginContainerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//    {
//    if ([segue.identifier isEqualToString:@"embedContainer"]) {
//    self.containerViewController = segue.destinationViewController;
//    }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "embedContainer"){
            self.containerViewController = segue.destinationViewController as InfoLoginContainerViewController
        }
    }
    @IBAction func changeViewController(sender: AnyObject) {
        containerViewController.swapViewControllers(sender.tag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func change(sender: AnyObject) {
//        containerViewController.swapViewControllers()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
