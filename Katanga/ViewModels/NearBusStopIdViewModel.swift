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

import RxCocoa
import RxSwift

struct NearBusStopIdViewModel: NearBusStopViewModel {

    private(set) var title: String
    private(set) var activityIndicator: ActivityIndicator

    let busStopId: String
	let apiClient: BusApi

	init(busStopId: String, apiClient: BusApi = KatangaBusApiClient()) {
        self.busStopId = busStopId
		self.apiClient = apiClient

        self.title = busStopId
        activityIndicator = ActivityIndicator()
    }

    func getNearBusStops() -> Driver<[NearBusStop]> {
        return apiClient
            .routeTimes(busStopId: busStopId)
            .trackActivity(activityIndicator)
            .toArray()
            .asDriver(onErrorJustReturn: [])
    }

}
