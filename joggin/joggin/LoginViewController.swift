//
//  LoginViewController.swift
//  joggin
//
//  Created by Victor Chirino on 3/4/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate{
    func startApplicationWithUser(user: PFUser)
}

class LoginViewController: UIViewController, FirstViewControllerDelegate, SecondViewControllerDelegate {
    
    var containerViewController: InfoLoginContainerViewController!
    var currentTag: NSInteger!
    var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentTag = 1

        // Do any additional setup after loading the view.
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "embedContainer"){
            self.containerViewController = segue.destinationViewController as InfoLoginContainerViewController
        }
    }
    @IBAction func changeViewController(sender: AnyObject) {
        if(sender.tag != currentTag){
            containerViewController.swapViewControllers(sender.tag)
            currentTag = sender.tag
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK FirstViewControllerDelegate
    
    func finishLogin(user: PFUser) {
        self.delegate?.startApplicationWithUser(user)
        self.dismissViewControllerAnimated(true, completion: nil)        
    }
    
    //MARK SecondViewControllerDelegate
    
    func finishCreate(user: PFUser) {
        self.delegate?.startApplicationWithUser(user)
        self.dismissViewControllerAnimated(true, completion: nil)
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
