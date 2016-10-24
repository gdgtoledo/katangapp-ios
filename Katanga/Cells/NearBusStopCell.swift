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

class NearBusStopCell: UITableViewCell {

    public var busStopName: String {
        set {
            busStopNameLabel.text = newValue
        }

        get {
            return busStopNameLabel.text ?? ""
        }
    }

    public var distance: String {
        set {
            distanceLabel.text = newValue
        }

        get {
            return distanceLabel.text ?? ""
        }
    }

    public var items: [BusStopTime] {
        set {
            _items.value.append(contentsOf: newValue)
        }

        get {
            return _items.value
        }
    }

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(BusComingCell.self)

            tableView.rowHeight = Constants.rowHeight
        }
    }

    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = Constants.cornerRadius
            containerView.layer.masksToBounds = true
        }
    }

    @IBOutlet private weak var busStopNameLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!

    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!

    private var disposeBag = DisposeBag()
    private var _items = Variable<[BusStopTime]>([])

    private struct Constants {
        static let cornerRadius: CGFloat = 10
        static let rowHeight: CGFloat = 40
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        tableView.customizeTableView(withColor: .clear)

        setupRx()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
        _items.value = []

        setupRx()
    }

    private func setupRx() {

        _items
            .asObservable()
            .bindTo(tableView.rx.items(cellType: BusComingCell.self)) { row, element, cell in
                cell.routeId = element.id
                cell.time = element.minutes
            }.addDisposableTo(disposeBag)

        _items
            .asObservable()
            .map { CGFloat($0.count) }
            .filter { $0 > 0 }
            .map {  $0 * Constants.rowHeight + self.headerHeightConstraint.constant }
            .bindTo(heightConstraint.rx.constant)
            .addDisposableTo(disposeBag)
    }

}
