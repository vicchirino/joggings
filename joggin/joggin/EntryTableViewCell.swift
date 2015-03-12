//
//  EntryTableViewCell.swift
//  joggin
//
//  Created by Victor Chirino on 3/6/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell, UITextFieldDelegate{
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.infoTextField.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}