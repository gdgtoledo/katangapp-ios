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
import RxCocoa
import RxSwift


class RouteDetailViewController : UIViewController, DataListTableView {

    typealias Model = BusStop
    typealias CellType = BusStopCell

    public var viewModel: RouteDetailViewModel?

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 200
        }
    }

	@IBOutlet private weak var toolbar: UIToolbar! {
		didSet {
			toolbar.tintColor = .katangaYellow
		}
	}

    private var disposeBag = DisposeBag()

	private lazy var mapViewController: UIViewController = {

		let storyboard = UIStoryboard(name: "Main", bundle: nil)

		let mapVC = storyboard.instantiateViewController(withIdentifier: "mapVC") as! MapViewController
		mapVC.viewModel = self.viewModel

		return mapVC
	}()

	private lazy var linesViewController: UIViewController = {

		let storyboard = UIStoryboard(name: "Main", bundle: nil)

		let linesVC = storyboard.instantiateViewController(withIdentifier: "linesVC") as! RouteStopsViewController
		linesVC.viewModel = self.viewModel

		return linesVC
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

		add(viewController: mapViewController)

        viewModel?.routeId()
            .drive(rx.title)
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

	@IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			add(viewController: mapViewController)
			remove(viewController: linesViewController)
		}
		else {
			add(viewController: linesViewController)
			remove(viewController: mapViewController)
		}
	}

	private func add(viewController: UIViewController) {
		addChildViewController(viewController)

		view.addSubview(viewController.view)

		viewController.view.translatesAutoresizingMaskIntoConstraints = false

		viewController.view.topAnchor.constraint(equalTo: self.toolbar.bottomAnchor).isActive = true
		viewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
		viewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		viewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

		viewController.didMove(toParentViewController: self)
	}

	private func remove(viewController: UIViewController) {
		viewController.willMove(toParentViewController: nil)

		viewController.view.removeFromSuperview()

		viewController.removeFromParentViewController()
	}

}
