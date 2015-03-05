//
//  InfoLoginContainerViewController.swift
//  joggin
//
//  Created by Victor Chirino on 3/4/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit


class InfoLoginContainerViewController: UIViewController {
    
    var currentSegueIdentifier:NSString!
    var firstViewController: FirstViewController!
    var secondViewController: SecondViewController!
    var transitionInProgress: Bool!
    let SegueIdentifierFirst = "embedFirst"
    let SegueIdentifierSecond = "embedSecond"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitionInProgress = false
        self.currentSegueIdentifier = SegueIdentifierFirst
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == SegueIdentifierFirst){
            self.firstViewController = segue.destinationViewController as FirstViewController
            var parentViewController = self.parentViewController as? LoginViewController
            self.firstViewController.delegate = parentViewController
        }
        
        if(segue.identifier == SegueIdentifierSecond){
            self.secondViewController = segue.destinationViewController as SecondViewController
            var parentViewController = self.parentViewController as? LoginViewController
            self.secondViewController.delegate = parentViewController
        }
        
        if(segue.identifier == SegueIdentifierFirst){
            if(self.childViewControllers.count > 0){
                    self.swapFromViewController(self.childViewControllers[0] as UIViewController, toViewController: self.firstViewController)
            }else{
                self.addChildViewController(segue.destinationViewController as UIViewController)
                var destView: UIView = segue.destinationViewController.view!!
                //Ver esto
                destView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
                destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                //Ver esto
                self.view.addSubview(destView)
                segue.destinationViewController.didMoveToParentViewController(self)
            }
        }else if(segue.identifier == SegueIdentifierSecond){
                self.swapFromViewController(self.childViewControllers[0] as UIViewController, toViewController: self.secondViewController)
        }
    }
    
    func swapFromViewController(fromViewController:UIViewController, toViewController:UIViewController){
        
        toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        fromViewController.willMoveToParentViewController(nil)
        self.addChildViewController(toViewController)
        
        self.transitionFromViewController(fromViewController, toViewController: toViewController, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromRight, animations: nil, completion: {finished in
                fromViewController.removeFromParentViewController()
                toViewController.didMoveToParentViewController(self)
                self.transitionInProgress = false
            })
    }
    
    func swapViewControllers(tag:NSInteger)
    {
        if(self.transitionInProgress == true){
            return
        }
        self.transitionInProgress = true
        
        if(tag == 1){
            self.currentSegueIdentifier = SegueIdentifierFirst
            if ((self.currentSegueIdentifier == SegueIdentifierSecond) && self.secondViewController != nil){
                self.swapFromViewController(self.firstViewController, toViewController: self.secondViewController)
                return
            }
        }else{
            self.currentSegueIdentifier = SegueIdentifierSecond
            if ((self.currentSegueIdentifier == SegueIdentifierFirst) && self.firstViewController != nil){
                self.swapFromViewController(self.secondViewController, toViewController: self.firstViewController)
                return
            }
        }
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
