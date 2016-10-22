//
//  File.swift
//  testTables
//
//  Created by Víctor Galán on 22/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import Foundation
import Marshal

struct Route : Unmarshaling {
    
    let id: String
    let link: String
    let name: String
    let busStops: [BusStop]
    
    init(object: MarshaledObject) throws {
        id = try object.value(for: "id")
        link = try object.value(for: "links.self")
        
        let rawName: String = try object.value(for: "name")
        name = rawName.components(separatedBy: ")").last ?? ""
    
        busStops = try object.value(for: "busStops")
    }
}
