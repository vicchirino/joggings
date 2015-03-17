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
    @IBOutlet weak var averageSpeedLabel: UILabel!
    
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
    
    func setTime(time: NSNumber){
        
        var hours = floor(time.floatValue/60)
        var minutes = time.floatValue - (hours * 60)
        var timeString = ""
        
        if(hours > 0){
            timeString = NSString(format: "%.f h and %.f m", hours,minutes)
        }else{
            timeString = NSString(format: "%.1f minutes",minutes)
        }
        self.timeLabel.text = timeString        
    }
    
    func setDate(date: NSDate){
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        var dayString: NSString = dateFormatter.stringFromDate(date)
        self.dateLabel.text = dayString
    }
    
    func setAverageSpeed(distance:NSString, time:NSNumber){
        var hours:Float = time.floatValue/60
        var velocityKmH = (distance.floatValue / hours)
        if hours == 0 {
            velocityKmH = 0
        }
        self.averageSpeedLabel.text = NSString(format: "Speed: %.1f km/h", velocityKmH)

    }
    
}
