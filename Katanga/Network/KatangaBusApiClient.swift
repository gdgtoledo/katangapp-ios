/**
 *    Copyright 2016-today Software Craftmanship Toledo
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*!
 @author Víctor Galán
 */

import Foundation
import Marshal
import RxSwift
import RxCocoa

struct KatangaBusApiClient : BusApi {

    let baseURL = "https://secret-depths-4660.herokuapp.com"

    var disposeBag = DisposeBag()

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
