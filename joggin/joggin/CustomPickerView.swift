//
//  CustomPickerView.swift
//  joggin
//
//  Created by Victor Chirino on 3/6/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

class CustomPickerView: UIView {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var picker: UIDatePicker!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var bundle = NSBundle.mainBundle()
        var nibsVies = bundle.loadNibNamed("CustomPickerView", owner: self, options: nil) as NSArray
        var mainView = nibsVies[0] as UIView
        mainView.frame = frame
        self.addSubview(mainView)
    }

    @IBAction func done(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationDoneButtonPicker, object: picker.date);
    }
    

}
