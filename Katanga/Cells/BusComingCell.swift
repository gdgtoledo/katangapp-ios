//
//  BusComingCell.swift
//  Katanga
//
//  Created by Víctor Galán on 23/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit

class BusComingCell: UITableViewCell {
    
    
    //MARK: Public variables
    
    public var routeId: String {
        set {
            routeIdLabel.text = newValue
        }
        get {
            return routeIdLabel.text ?? ""
        }
    }
    
    public var time: Double {
        set {
            timeLabel.text = setTimeText(forMinutes: newValue)
        }
        get {
            return 0
        }
    }
    
    
    //MARK: Private constants
    
    private let busInStopColor =
            UIColor(red: 255/255.0, green: 75/255.0, blue: 69/255.0, alpha: 1.0)
    
    private let nearBusColor =
        UIColor(red: 255/255.0, green: 179/255.0, blue: 0/255.0, alpha: 1.0)
    
    
    //MARK: Outlets
    
    @IBOutlet private weak var routeIdLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    
    //MARK: UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        routeIdLabel.text = ""
        timeLabel.text = ""
        
        timeLabel.textColor = .black
    }
    
    
    //MARK: Private methods
    
    private func setTimeText(forMinutes minutes: Double) -> String {
        let mins = Int(minutes)
        
        var text = "\(mins) minutos"
        
        if mins <= 5 {
            timeLabel.textColor = busInStopColor
        }
        else if mins < 10 {
            timeLabel.textColor = nearBusColor
        }
        
        if mins == 0 {
            text = "PRÓXIMO"
        }
        else if mins > 60 {
            text = "60+ minutos"
        }
        
        return text
    }
}
