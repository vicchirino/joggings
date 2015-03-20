//
//  ListInterfaceController.swift
//  joggin
//
//  Created by Victor Chirino on 3/20/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import WatchKit
import Foundation


class ListInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override init () {
        // Initialize variables here.
        super.init()
        
        // It is now safe to access interface objects.
        self.configureTableWithData()
    }
    
    func configureTableWithData(){
        self.table.setNumberOfRows(10, withRowType: "joggingCell")
        var index: Int
        for index = 0; index < self.table.numberOfRows; index++
        {
            var theRow = self.table.rowControllerAtIndex(index) as MyRowController
            theRow.distanceLabel.setText("10 km")
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }


}
