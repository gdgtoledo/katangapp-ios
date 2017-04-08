//
//  FavoriteBusStopCell.swift
//  Katanga
//
//  Created by Víctor Galán on 2/4/17.
//  Copyright © 2017 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit

class FavoriteBusStopCell: UITableViewCell {
	
	var busStopId: String? {
		set {
			busStopIdLabel.text = newValue
		}
		get {
			return busStopIdLabel.text ?? ""
		}
	}
	
	var busStopAddress: String? {
		set {
			busStopAddressLabel.text = newValue
		}
		get {
			return busStopAddressLabel.text ?? ""
		}
	}

	@IBOutlet weak var busStopIdLabel: UILabel!
	@IBOutlet weak var busStopAddressLabel: UILabel!
}
