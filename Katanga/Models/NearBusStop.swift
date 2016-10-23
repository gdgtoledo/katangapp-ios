//
//  NearBusStop.swift
//  Katanga
//
//  Created by Víctor Galán on 23/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import Foundation
import Marshal

struct NearBusStop : Unmarshaling {
    let busStop: BusStop
    let times: [BusStopTime]
    let distance: Double
    
    init(object: MarshaledObject) throws {
        busStop = try object.value(for: "parada")
        times = try object.value(for: "tiempos")
        distance = try object.value(for: "distancia")
    }
    
}

struct BusStopTime : Unmarshaling {
    let id: String
    let minutes: Double
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: "idl")
        minutes = try object.value(for: "time")
    }
}
