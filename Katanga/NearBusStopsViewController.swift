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

    private var disposeBag = DisposeBag()
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
        
        setupRx()
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
            .addDisposableTo(disposeBag)

        tableView.addSubview(refreshControl!)

        viewModel.activityIndicator.asObservable()
            .take(2)
            .bindTo(spinner.rx.isAnimating)
            .addDisposableTo(disposeBag)
        
        viewModel.activityIndicator
            .drive(refreshControl!.rx.refreshing)
            .addDisposableTo(disposeBag)
        
    }
    
    func fillCell(row: Int, element: NearBusStop, cell: NearBusStopCell) {
        cell.busStopName = element.busStop.address
        
        let distanceFormatted = String(format: "%.2f", element.distance)
        
        cell.distance = "(\(distanceFormatted) metros)"
        cell.bustStopTimes = element.times
    }
}
