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

import RxSwift
import RxCocoa

struct NearBusStopCoordinatesViewModel : NearBusStopViewModel {

    private(set) var title: String
    private(set) var activityIndicator: ActivityIndicator

    let latitude: Double
    let longitude: Double
    let meters: Int

    init(latitude: Double, longitude: Double, meters: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.meters = meters

        self.title = "Paradas cercanas"
        activityIndicator = ActivityIndicator()
    }

    func getNearBusStops() -> Driver<[NearBusStop]> {
       return KatangaBusApiClient()
            .nearbyBusStops(latitude: latitude, longitude: longitude, meters: meters)
            .trackActivity(activityIndicator)
            .toArray()
            .asDriver(onErrorJustReturn: [])
    }

}
