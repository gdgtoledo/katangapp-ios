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

struct Route : Unmarshaling {

    let busStops: [BusStop]
    let id: String
    let link: String
    let name: String

    init(object: MarshaledObject) throws {
        id = try object.value(for: "id")
        link = try object.value(for: "links.self")

        let rawName: String = try object.value(for: "name")

        name = rawName.components(separatedBy: ")").last ?? ""

        busStops = try object.value(for: "busStops")
    }

}
