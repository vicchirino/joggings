//
//  FirstViewController.swift
//  joggin
//
//  Created by Victor Chirino on 3/5/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

protocol FirstViewControllerDelegate {
    func finishLogin(user: PFUser)
}

class FirstViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var delegate: FirstViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func login(sender: AnyObject) {
        self.login(usernameTextField.text, password: passwordTextField.text)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func checkParameters() -> Bool
    {
        var textfieldArray = [usernameTextField.text, passwordTextField.text]
        for text in textfieldArray {
            if text as NSString == "" {
                return false
            }
        }
        return true
    }
    
    func dropKeyboard(){
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func createAlert(title: NSString, message: NSString) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: UITextFieldDelegate methods
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        if(textField == usernameTextField){
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        
        return true;
    }
    
    //MARK: Parse
    
    func login(username: NSString, password: NSString) {
        
        PZUILoader.sharedLoader().show()
        
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser!, error: NSError!) -> Void in
            
            PZUILoader.sharedLoader().hide()
            
            if user != nil {
                
                let loginViewController = self.parentViewController?.parentViewController as LoginViewController!
                self.delegate = loginViewController!
                self.delegate.finishLogin(user)
                
            } else {
                var info = error.userInfo!
                let errorString = info["error"] as NSString
                self.createAlert("Error", message: errorString)
                // The login failed. Check error to see why.
            }
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
