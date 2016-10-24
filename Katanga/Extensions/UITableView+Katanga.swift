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

extension UITableView {

    func register<T: UITableViewCell>(_ : T.Type) where T: NibLoadableView, T: ReusableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)

        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

}

extension Reactive where Base : UITableView {

    func items<S: Sequence, Cell: UITableViewCell, O : ObservableType>
        (cellType: Cell.Type = Cell.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable

        where O.E == S, Cell : ReusableView {

        return items(cellIdentifier: cellType.reuseIdentifier, cellType: cellType)
    }

}

extension UITableView {

    func customizeTableView(withColor color: UIColor) {
        backgroundColor = color
        layoutMargins = UIEdgeInsets.zero
        separatorColor = color
        separatorInset = UIEdgeInsets.zero
    }

}
