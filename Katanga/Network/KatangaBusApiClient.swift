//
//  KatangaBusApiClient.swift
//  Katanga
//
//  Created by Víctor Galán on 22/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Marshal

struct KatangaBusApiClient : BusApi {
    
    var disposeBag = DisposeBag()
    
    let baseURL = "https://secret-depths-4660.herokuapp.com"
    
    func allRoutes() -> Observable<Route> {
        let url = URL(string: "\(baseURL)/api/routes")!
        let request = URLRequest(url: url)
        
        return URLSession.shared.rx.data(request: request)
            .map { try JSONParser.JSONArrayWithData($0) }
            .flatMap { Observable.from($0) }
            .map { try $0.value(for: "") as Route }
    }
    
    func nearbyBusStops(latitude: Double, longitude: Double, meters: Int) -> Observable<NearBusStop> {
        
        let url = URL(string: "\(baseURL)/main?lt=\(latitude)&ln=\(longitude)&r=\(meters)")!
        let request = URLRequest(url: url)
        
        return URLSession.shared.rx.data(request: request)
            .debug()
            .map { try JSONParser.JSONObjectWithData($0) }
            .map { try $0.value(for: "paradas")}
            .flatMap { Observable.from($0) }
    }
}
