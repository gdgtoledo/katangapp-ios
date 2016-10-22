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
        
        return URLSession.shared.rx.data(request)
            .flatMap { Observable.of(try JSONParser.JSONArrayWithData($0)) }
            .flatMap { Observable.from($0) }
            .map { try $0.value(for: "") as Route }
    }
}
