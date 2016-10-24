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

struct NearBusStop : Unmarshaling {

    let busStop: BusStop
    let distance: Double
    let times: [BusStopTime]

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
