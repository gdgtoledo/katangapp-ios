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

class NearBusStopsViewController: UIViewController, DataListTableView {

    typealias Model = NearBusStop
    typealias CellType = NearBusStopCell

    var viewModel: NearBusStopViewModel?

    private var refreshControl: UIRefreshControl?

    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 200
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize(tableView: tableView)

		self.hidesBottomBarWhenPushed = true

        setupRx()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = NSLocalizedString("near-stops", comment: "")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }

    private func setupRx() {
        guard let viewModel = viewModel else { return }

        title = viewModel.title

        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = .katangaYellow

        let driver = refreshControl!.rx.controlEvent(.valueChanged)
            .startWith(())
            .flatMap {
                viewModel.getNearBusStops()
            }
            .asDriver(onErrorJustReturn: [])

        bindViewModel(tableView: tableView, driver: driver)
            .disposed(by: rx_disposeBag)

        tableView.addSubview(refreshControl!)

        viewModel.activityIndicator.asObservable()
            .take(2)
            .bindTo(spinner.rx.isAnimating)
            .disposed(by: rx_disposeBag)

        viewModel.activityIndicator
            .drive(refreshControl!.rx.isRefreshing)
            .disposed(by: rx_disposeBag)

    }

    func fillCell(row: Int, element: NearBusStop, cell: NearBusStopCell) {
        cell.busStopName = element.busStop.address

        let distanceFormatted = String(format: "%.2f", element.distance)

        cell.distance = "(\(distanceFormatted) \(NSLocalizedString("meters", comment: "")))"
        cell.bustStopTimes = element.times
        cell.routeItemClick = { [weak self] routeId in
            self?.performSegue(withIdentifier: "routedetail", sender: routeId)
        }
        cell.busStopClick = { [weak self] in
            self?.performSegue(withIdentifier: "busStopDetail", sender: element.busStop)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "routedetail" {
            guard let routeId = sender as? String else {
                return
            }
            let vc = segue.destination as? RouteDetailViewController
            let vm = RouteDetailViewModelFromNearBuses(routeIdentifier: routeId)

            vc?.viewModel = vm
        }
        else if segue.identifier == "busStopDetail" {
            guard let busStop = sender as? BusStop else {
                return
            }

            let vc = segue.destination as? BusStopDetailViewController
			vc?.viewModel = BusStopDetailViewModel(busStop: busStop)
        }
    }

}
