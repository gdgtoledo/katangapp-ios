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
import RxSwift
import RxCocoa

protocol RouteDetailViewModelProtocol {

    func getBusStops() -> Driver<[BusStop]>
    func routeId() -> Driver<String>
}

struct RouteDetailViewModel: RouteDetailViewModelProtocol {

	let route: Route

	func getBusStops() -> Driver<[BusStop]> {
		return Observable.of(route.busStops).asDriver(onErrorJustReturn: [])
	}

    func routeId() -> Driver<String> {
        return Driver.of(route.id)
    }

}

struct RouteDetailViewModelFromNearBuses: RouteDetailViewModelProtocol {

	let apiClient: BusApi
    let routeIdentifier: String

	init(apiClient: BusApi = KatangaBusApiClient(), routeIdentifier: String) {
		self.apiClient = apiClient
		self.routeIdentifier = routeIdentifier
	}

    func getBusStops() -> Driver<[BusStop]> {
        return apiClient.route(with: routeIdentifier)
                    .map { $0.busStops }.asDriver(onErrorJustReturn: [])
    }

    func routeId() -> Driver<String> {
        return Driver.of(routeIdentifier)
    }

}
