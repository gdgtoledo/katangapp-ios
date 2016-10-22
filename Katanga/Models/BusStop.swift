//
//  BusStop.swift
//  testTables
//
//  Created by Víctor Galán on 22/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import Foundation
import Marshal

struct BusStop : Unmarshaling {
    
    let address: String
    let id: String
    let latitude: Double
    let longitude: Double
    let routeId: String
    
    init(object: MarshaledObject) throws {
        address = try object.value(for: "address")
        id = try object.value(for: "id")
        latitude = try object.value(for: "latitude")
        longitude = try object.value(for: "longitude")
        routeId = try object.value(for: "routeId")
    }
}
