//
//  SecondViewController.swift
//  joggin
//
//  Created by Victor Chirino on 3/4/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

protocol SecondViewControllerDelegate {
    func finishCreate(user: PFUser)
}

class SecondViewController: UIViewController {
   
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var repeatPasswordTextfield: UITextField!
    @IBAction func touchUsername(sender: AnyObject) {
        self.usernameTextfield.becomeFirstResponder()
    }
    @IBAction func touchPassword(sender: AnyObject) {
        self.passwordTextfield.becomeFirstResponder()
    }
    @IBAction func touchRepeatPassword(sender: AnyObject) {
        self.repeatPasswordTextfield.becomeFirstResponder()
    }
    var delegate: SecondViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createUser(sender: AnyObject) {
        if !self.checkParameters(){
            self.createAlert("Oops we encountered an error", message: "All of the fields must be filled")
            return
        }
        
        if passwordTextfield.text != repeatPasswordTextfield.text {
            self.createAlert("Oops we encountered an error", message: "The two passwords don't match")
            return
        }
        
        self.singnUp(usernameTextfield.text, password: passwordTextfield.text)
        
    }
    
    
    func checkParameters() -> Bool
    {
        var textfieldArray = [usernameTextfield.text, passwordTextfield.text, repeatPasswordTextfield.text]
        for text in textfieldArray {
            if text as NSString == "" {
                return false
            }
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func createAlert(title: NSString, message: NSString) {        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //MARK: UITextFieldDelegate methods

    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        if(textField == usernameTextfield){
            textField.resignFirstResponder()
            passwordTextfield.becomeFirstResponder()
        }else if(textField == passwordTextfield){
            textField.resignFirstResponder()
            repeatPasswordTextfield.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        
        return true;
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        
        if ((range.length + range.location) > textField.text.utf16Count){
            return false
        }
        
        var newLength = textField.text.utf16Count + string.utf16Count - range.length
        
        if newLength > 10 {
            return false
        }else{
            return true
        }
    }
        
    func dropKeyboard(){
        usernameTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        repeatPasswordTextfield.resignFirstResponder()
    }
    
    
    //MARK: Parse
    func singnUp(username: NSString, password: NSString) {
        
        PZUILoader.sharedLoader().show()
        
        var user = PFUser()
        user.username = username
        user.password = password
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            
            PZUILoader.sharedLoader().hide()
            
            if error == nil {
                self.delegate?.finishCreate(user)

            } else {
                var info = error.userInfo!
                let errorString = info["error"] as NSString
                self.createAlert("Error", message: errorString)
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
