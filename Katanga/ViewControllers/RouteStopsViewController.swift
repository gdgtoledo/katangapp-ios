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
import UIKit

class RouteStopsViewController: UIViewController, DataListTableView {

	typealias Model = BusStop
	typealias CellType = BusStopCell

	public var viewModel: RouteDetailViewModel?

	@IBOutlet private var tableView: UITableView! {
		didSet {
			tableView.rowHeight = UITableViewAutomaticDimension
			tableView.estimatedRowHeight = 200
		}
	}

	private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

		initialize(tableView: tableView)
		
		bindViewModel(tableView: tableView, driver: viewModel!.getBusStops())
			.addDisposableTo(disposeBag)

		tableView.rx.modelSelected(BusStop.self)
			.subscribe(onNext: { [weak self] in
				self?.performSegue(withIdentifier: "times", sender: $0)
			})
			.addDisposableTo(disposeBag)
    }

	func fillCell(row: Int, element: Model, cell: CellType) {
		cell.busStopName = element.address
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let busStop = sender as? BusStop else { return }

		let viewModel = NearBusStopIdViewModel(busStopId: busStop.id)
		let vc = segue.destination as? NearBusStopsViewController

		vc?.viewModel = viewModel
	}

}
