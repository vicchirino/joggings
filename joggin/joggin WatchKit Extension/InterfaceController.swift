//
//  InterfaceController.swift
//  joggin WatchKit Extension
//
//  Created by Victor Chirino on 3/19/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var label: WKInterfaceLabel!
    @IBOutlet weak var button: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override init () {
        // Initialize variables here.
        super.init()
        
        // It is now safe to access interface objects.
        label.setText("Average Speed 23 km/h")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
//        var initialPhrases = ["Let's do lunch.","Can we meet tomorow?","When are you free?"]
//        
//        self.presentTextInputControllerWithSuggestions(initialPhrases, allowedInputMode: WKTextInputMode.AllowAnimatedEmoji, completion:{(results: [AnyObject]!) -> Void in
//            
//            if (((results) != nil) && results.count > 0){
//                    var aResult: AnyObject = results[0]
//            }else{
//                
//            }
//        })
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func buttonPressed() {
        self.presentControllerWithName("SecondInterfaceController", context: nil)
    }
    

}
