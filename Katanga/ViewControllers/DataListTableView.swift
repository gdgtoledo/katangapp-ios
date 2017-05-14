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

protocol DataListTableView {

    associatedtype Model
    associatedtype CellType: UITableViewCell

    func fillCell(row: Int, element: Model, cell: CellType)
}

extension DataListTableView where CellType : NibLoadableView & ReusableView {

    func bindViewModel(tableView: UITableView, driver: Driver<[Model]>) -> Disposable {

        return driver.drive(tableView.rx.items(cellType: CellType.self)) { row, element, cell in
            self.fillCell(row: row, element: element, cell: cell)
        }
    }

    func initialize(tableView: UITableView) {
        tableView.register(CellType.self)

        tableView.customizeTableView(withColor: .black)

        tableView.tableFooterView = UIView()

        tableView.separatorStyle = .none
    }
}
