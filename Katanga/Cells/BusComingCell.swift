//
//  BusComingCell.swift
//  Katanga
//
//  Created by Víctor Galán on 23/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit

class BusComingCell: UITableViewCell {
    
    public var routeId: String {
        set {
            routeIdLabel.text = newValue
        }
        get {
            return routeIdLabel.text ?? ""
        }
    }
    
    public var time: String {
        set {
            timeLabel.text = newValue
        }
        get {
            return timeLabel.text ?? ""
        }
    }
    
    @IBOutlet private weak var routeIdLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        routeIdLabel.text = ""
        timeLabel.text = ""
    }
}
