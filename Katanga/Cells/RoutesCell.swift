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

import UIKit

class RoutesCell: UITableViewCell {

    public var routeId: String {
        set {
            _routeIdLabel.text = newValue
        }

        get {
            return _routeIdLabel.text ?? ""
        }
    }

    public var routeName: String {
        set {
            _routeNameLabel.text = newValue
        }

        get {
            return _routeNameLabel.text ?? ""
        }
    }

    @IBOutlet private weak var _containerView: UIView! {
        didSet {
            _containerView.layer.cornerRadius = 3
            _containerView.layer.masksToBounds = true
        }
    }

    @IBOutlet private weak var _routeIdLabel: UILabel!
    @IBOutlet private weak var _routeNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        _routeIdLabel.text = ""
        _routeNameLabel.text = ""
    }

}
