//
//  RoutesCell.swift
//  Katanga
//
//  Created by Víctor Galán on 22/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit

class RoutesCell: UITableViewCell {
    
    
    //MARK: Public variables
    
    public var routeId: String {
        set {
            routeIdLabel.text = newValue
        }
        get {
            return routeIdLabel.text ?? ""
        }
    }
    
    public var routeName: String {
        set {
            routeNameLabel.text = newValue
        }
        get {
            return routeNameLabel.text ?? ""
        }
    }
    
    
    //MARK: Outlets
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 3
            containerView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet private weak var routeIdLabel: UILabel!
    @IBOutlet private weak var routeNameLabel: UILabel!
    
    
    //MARK: UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        routeIdLabel.text = ""
        routeNameLabel.text = ""
    }
    
}
