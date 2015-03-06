//
//  HomeTableViewCell.swift
//  joggin
//
//  Created by Victor Gabriel Chirino on 3/6/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setDistance(distance:NSString){
       //Fixme ver el tema de millas y kilometros.
        distanceLabel.text = NSString(format: "%@ km", distance)
    }
    
    func setTime(time: NSString){
    
    }
    
    func setDate(time: NSString){
        
    }
    
}
