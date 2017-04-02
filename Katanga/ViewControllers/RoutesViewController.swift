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

class RoutesViewController : UIViewController, DataListTableView {

    typealias Model = Route
    typealias CellType = RoutesCell

    @IBOutlet private weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }

	@IBOutlet private weak var tableView: UITableView! {
		didSet {
			tableView.rowHeight = 60
		}
	}

    private let activityIndicator = ActivityIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize(tableView: tableView)

		tableView.separatorStyle = .singleLineEtched
		tableView.separatorColor = .white

        setupRx()
    }

    private func setupRx() {
        let driver = KatangaBusApiClient().allRoutes()
            .trackActivity(activityIndicator)
            .toArray()
            .asDriver(onErrorJustReturn: [])
        
        bindViewModel(tableView: tableView, driver: driver)
            .disposed(by: rx_disposeBag)

        activityIndicator
            .drive(spinner.rx.isAnimating)
            .disposed(by: rx_disposeBag)

		tableView.rx.modelSelected(Route.self).subscribe(onNext: { [weak self] in
			let viewModel = RouteDetailViewModel(route: $0)
            self?.performSegue(withIdentifier: "detail", sender: viewModel)
		})
		.disposed(by: rx_disposeBag)
    }

    func fillCell(row: Int, element: Route, cell: RoutesCell) {
        cell.routeId = element.id
        cell.routeName = element.name
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! RouteDetailViewController
        
        vc.viewModel = sender as? RouteDetailViewModel
    }

}
