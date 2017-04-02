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
import RealmSwift

class BusStopRealm : Object {
	
	dynamic var address: String = ""
	dynamic var id: String = ""
	dynamic var latitude: Double = 0
	dynamic var longitude: Double = 0
	dynamic var routeId: String? = ""
	
	convenience init(address: String, id: String, latitude: Double, longitude: Double, routeId: String?) {
		self.init()
		self.address = address
		self.id = id
		self.latitude = latitude
		self.longitude = longitude
		self.routeId = routeId
	}
	
	override static func primaryKey() -> String? {
		return "id"
	}
}
