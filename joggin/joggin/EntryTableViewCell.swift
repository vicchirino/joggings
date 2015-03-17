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
    
    func canAddACharacter(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            if self.canAddACharacter(textField, shouldChangeCharactersInRange: range, replacementString: string){
                return true
            }else{
                return false
            }
        case ".":
            let array = Array(textField.text)
            var decimalCount = 0
            for character in array {
                if character == "." {
                    decimalCount++
                }
            }
            
            if decimalCount == 1 {
                return false
            } else {
                if self.canAddACharacter(textField, shouldChangeCharactersInRange: range, replacementString: string){
                    return true
                }else{
                    return false
                }            }
        default:
            let array = Array(string)
            if array.count == 0 {
                if self.canAddACharacter(textField, shouldChangeCharactersInRange: range, replacementString: string){
                    return true
                }else{
                    return false
                }            }
            return false
        }
    }
}
    