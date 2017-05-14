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
            routeIdLabel.text = newValue
        }

        get {
            return routeIdLabel.text ?? ""
        }
    }

    public var routeName: String {
        set {
            routeNameLabel.text = newValue
        }

        get {
            return routeNameLabel.text ?? ""
        }
    }

    @IBOutlet private weak var containerView: UIView!

    @IBOutlet private weak var routeIdLabel: UILabel!
    @IBOutlet private weak var routeNameLabel: UILabel!
	@IBOutlet weak var circleView: UIView! {
		didSet {
			circleView.layer.cornerRadius = circleView.frame.width/2
			circleView.backgroundColor = .katangaYellow
			circleView.layer.borderWidth = 2
			circleView.layer.borderColor = UIColor.black.cgColor
			circleView.layer.contentsScale = UIScreen.main.scale

			// Outer border
			let layer = CALayer()
			let layerFrame = CGRect(x: self.circleView.bounds.origin.x - 2,
			                        y: self.circleView.bounds.origin.y - 2,
			                        width: self.circleView.frame.width + 4,
			                        height: self.circleView.frame.height + 4)
			layer.frame = layerFrame

			layer.borderWidth = 2
			layer.borderColor = UIColor.white.cgColor
			layer.cornerRadius = layer.frame.width/2

			circleView.layer.addSublayer(layer)
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

	override func layoutSubviews() {
		super.layoutSubviews()

	}

    override func prepareForReuse() {
        super.prepareForReuse()

        routeIdLabel.text = ""
        routeNameLabel.text = ""
    }

}
