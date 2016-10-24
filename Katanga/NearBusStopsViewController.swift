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

    private let _activityIndicator = ActivityIndicator()

    private var _disposeBag = DisposeBag()
    private var _nearBusStops: Driver<[NearBusStop]>?
    private var _refreshControl: UIRefreshControl?
    private var _refreshControlBag = DisposeBag()

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

        _nearBusStops = KatangaBusApiClient()
                .nearbyBusStops(latitude: 39.861293, longitude: -4.026146, meters: 1000)
                .trackActivity(_activityIndicator)
                .scan([], accumulator: { $0 + [$1] })
                .asDriver(onErrorJustReturn: [])

        setupRx()
    }

    private func setupRefresh() {
        _refreshControl = UIRefreshControl()
        _refreshControl?.tintColor = .katangaYellow

        _refreshControl?.rx.controlEvent(.valueChanged)
            .bindNext { [weak self] in
                self?._disposeBag = DisposeBag()
                self?.setupRx()
            }
            .addDisposableTo(_refreshControlBag)

        tableView.addSubview(_refreshControl!)

        _activityIndicator
            .drive(_refreshControl!.rx.refreshing)
            .addDisposableTo(_refreshControlBag)
    }

    private func setupRx() {
            _nearBusStops?.drive(tableView.rx.items(cellType: NearBusStopCell.self)) { row, nearBusStop, cell in
                cell.busStopName = nearBusStop.busStop.address

                let distanceFormatted = String(format: "%.2f", nearBusStop.distance)

                cell.distance = "(\(distanceFormatted) metros)"
                cell.items = nearBusStop.times
            }
            .addDisposableTo(_disposeBag)

        _activityIndicator
            .drive(spinner.rx.isAnimating)
            .addDisposableTo(_disposeBag)
    }

}
