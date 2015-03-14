//
//  EmptyView.swift
//  joggin
//
//  Created by Victor Gabriel Chirino on 3/14/15.
//  Copyright (c) 2015 Victor Chirino. All rights reserved.
//

import UIKit

class EmptyView: UIView {

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
        var nibsVies = bundle.loadNibNamed("EmptyView", owner: self, options: nil) as NSArray
        var mainView = nibsVies[0] as UIView
        mainView.frame = frame
        self.addSubview(mainView)
    }
}
