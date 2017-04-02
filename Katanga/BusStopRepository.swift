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

class BusStopRepository {
	
	func save(_ input: BusStop) {
		let stopRealm = map(input)
		let realm = try! Realm()
		try! realm.write {
			realm.add(stopRealm, update: true)
		}
	}
	
	func remove(_ input: BusStop) {
		let realm = try! Realm()
		if let stop = realm.object(ofType: BusStopRealm.self, forPrimaryKey: input.id) {
			try! realm.write {
				realm.delete(stop)
			}
		}
	}
	
	func exists(_ input: BusStop) -> Bool {
		let realm = try! Realm()
		if let _ = realm.object(ofType: BusStopRealm.self, forPrimaryKey: input.id) {
			return true
		}
		return false
	}
	
	func getAll() -> [BusStop] {
		let realm = try! Realm()
		return realm.objects(BusStopRealm.self).map(reverseMap)
	}
	
	private func map(_ input: BusStop) -> BusStopRealm {
		return BusStopRealm(address: input.address, id: input.id, latitude: input.latitude,
			longitude: input.longitude, routeId: input.routeId)
	}
	
	private func reverseMap(_ input: BusStopRealm) -> BusStop {
		return BusStop(address: input.address, id: input.id, latitude: input.latitude,
			longitude: input.longitude, routeId: input.routeId)
	}
	
}
