//
//  Jogging.swift
//  joggin
//
//  Created by Victor Chirino on 3/6/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

class Jogging: PFObject, PFSubclassing {
    
    @NSManaged var date: NSDate!
    @NSManaged var distanceKm: NSString!
    @NSManaged var minutes: NSNumber!
    @NSManaged var userID: PFUser!

    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    class func parseClassName() -> String! {
        return "Jogging"
    }
   
}

