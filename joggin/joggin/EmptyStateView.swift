//
//  EmptyStateView.swift
//  joggin
//
//  Created by Victor Chirino on 3/6/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {
    
    @IBOutlet weak var descriptionLabel: UILabel!
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
        self.descriptionLabel = UILabel()
        var bundle = NSBundle.mainBundle()
        var nibsVies = bundle.loadNibNamed("EmptyStateView", owner: self, options: nil) as NSArray
        var mainView = nibsVies[0] as UIView
        mainView.frame = frame
        self.addSubview(mainView)        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
