//
//  BusApi.swift
//  Katanga
//
//  Created by Víctor Galán on 22/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import Foundation
import RxSwift

protocol BusApi {
    
    func allRoutes() -> Observable<Route>
    
    func nearbyBusStops(latitude: Double, longitude: Double, meters: Int) -> Observable<NearBusStop>
}
