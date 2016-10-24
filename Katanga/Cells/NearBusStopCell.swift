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
            _busStopNameLabel.text = newValue
        }

        get {
            return _busStopNameLabel.text ?? ""
        }
    }

    public var distance: String {
        set {
            _distanceLabel.text = newValue
        }

        get {
            return _distanceLabel.text ?? ""
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

    @IBOutlet private weak var _busStopNameLabel: UILabel!

    @IBOutlet private weak var _containerView: UIView! {
        didSet {
            _containerView.layer.cornerRadius = Constants.cornerRadius
            _containerView.layer.masksToBounds = true
        }
    }

    @IBOutlet private weak var _distanceLabel: UILabel!
    @IBOutlet private weak var _heightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var _headerHeightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var _tableView: UITableView! {
        didSet {
            _tableView.register(BusComingCell.self)

            _tableView.rowHeight = Constants.rowHeight
        }
    }

    private var _disposeBag = DisposeBag()
    private var _items = Variable<[BusStopTime]>([])

    private struct Constants {
        static let cornerRadius: CGFloat = 10
        static let rowHeight: CGFloat = 40
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        _tableView.customizeTableView(withColor: .clear)

        setupRx()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        _disposeBag = DisposeBag()

        _items.value = []

        setupRx()
    }

    private func setupRx() {
        _items
            .asObservable()
            .bindTo(_tableView.rx.items(cellType: BusComingCell.self)) { row, element, cell in
                cell.routeId = element.id
                cell.time = element.minutes
            }.addDisposableTo(_disposeBag)

        _items
            .asObservable()
            .map { CGFloat($0.count) }
            .filter { $0 > 0 }
            .map {  $0 * Constants.rowHeight + self._headerHeightConstraint.constant }
            .bindTo(_heightConstraint.rx.constant)
            .addDisposableTo(_disposeBag)
    }

}
