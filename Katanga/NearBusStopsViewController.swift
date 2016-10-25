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

class NearBusStopsViewController: UIViewController {

    private let activityIndicator = ActivityIndicator()

    private var disposeBag = DisposeBag()
    private var nearBusStops: Driver<[NearBusStop]>?
    private var refreshControl: UIRefreshControl?
    private var refreshControlBag = DisposeBag()

    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(NearBusStopCell.self)
            tableView.tableFooterView = UIView()

            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 200
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRefresh()

        tableView.customizeTableView(withColor: .black)

        nearBusStops = KatangaBusApiClient()
                .nearbyBusStops(latitude: 39.861293, longitude: -4.026146, meters: 1000)
                .trackActivity(activityIndicator)
                .scan([], accumulator: { $0 + [$1] })
                .asDriver(onErrorJustReturn: [])

        setupRx()
    }

    private func setupRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .katangaYellow

        refreshControl?.rx.controlEvent(.valueChanged)
            .bindNext { [weak self] in
                self?.disposeBag = DisposeBag()
                self?.setupRx()
            }
            .addDisposableTo(refreshControlBag)

        tableView.addSubview(refreshControl!)

        activityIndicator
            .drive(refreshControl!.rx.refreshing)
            .addDisposableTo(refreshControlBag)
    }

    private func setupRx() {
            nearBusStops?.drive(tableView.rx.items(cellType: NearBusStopCell.self)) { row, nearBusStop, cell in
                cell.busStopName = nearBusStop.busStop.address

                let distanceFormatted = String(format: "%.2f", nearBusStop.distance)

                cell.distance = "(\(distanceFormatted) metros)"
                cell.bustStopTimes = nearBusStop.times
            }
            .addDisposableTo(disposeBag)

        activityIndicator
            .drive(spinner.rx.isAnimating)
            .addDisposableTo(disposeBag)
    }

}
