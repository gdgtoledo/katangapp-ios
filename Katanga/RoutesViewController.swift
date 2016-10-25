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

class RoutesViewController : UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(RoutesCell.self)
            tableView.tableFooterView = UIView()
        }
    }

    private let activityIndicator = ActivityIndicator()

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.customizeTableView(withColor: .black)

        setupRx()
    }

    private func setupRx() {
        KatangaBusApiClient().allRoutes()
            .trackActivity(activityIndicator)
            .scan([], accumulator: { $0 + [$1] })
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellType: RoutesCell.self)) { row, route, routeCell in
                routeCell.routeId = route.id
                routeCell.routeName = route.name
            }
            .addDisposableTo(disposeBag)

        activityIndicator
            .drive(spinner.rx.isAnimating)
            .addDisposableTo(disposeBag)
    }

}
