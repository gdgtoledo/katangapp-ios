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

import UIKit
import RxSwift
import RxCocoa

class FavoriteBusStopsViewController: UIViewController, DataListTableView, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.rowHeight = 80
			tableView.layoutMargins = .zero
			tableView.separatorColor = .black
			tableView.separatorInset = .zero
			tableView.tableFooterView = UIView()

			tableView.dataSource = self
			tableView.delegate = self
		}
	}

	let viewModel = FavoriteBusStopsViewModel()

	var busStops = [BusStop]()

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.register(FavoriteBusStopCell.self)

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		busStops = viewModel.getFavorites()
		tableView.reloadData()
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return busStops.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: FavoriteBusStopCell.reuseIdentifier, for: indexPath)
			as! FavoriteBusStopCell

		fillCell(row: indexPath.row, element: busStops[indexPath.row], cell: cell)

		return cell
	}

	func fillCell(row: Int, element: BusStop, cell: FavoriteBusStopCell) {
		cell.busStopId = element.id
		cell.busStopAddress = element.address
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
			forRowAt indexPath: IndexPath) {

		let busStop = busStops[indexPath.row]

		viewModel.removeFavorite(busStop: busStop)

		tableView.beginUpdates()
		tableView.deleteRows(at: [indexPath], with: .automatic)
		busStops.remove(at: indexPath.row)
		tableView.endUpdates()
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let busStop = busStops[indexPath.row]
		performSegue(withIdentifier: "times", sender: busStop)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let busStop = sender as? BusStop else { return }

		let viewModel = NearBusStopIdViewModel(busStopId: busStop.id)
		let vc = segue.destination as? NearBusStopsViewController

		vc?.viewModel = viewModel
	}
}
