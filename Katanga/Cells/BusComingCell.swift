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

class BusComingCell: UITableViewCell {

    private let busInStopColor =
        UIColor(red: 255/255.0, green: 75/255.0, blue: 69/255.0, alpha: 1.0)

    private let nearBusColor =
        UIColor(red: 255/255.0, green: 179/255.0, blue: 0/255.0, alpha: 1.0)

    public var routeId: String {
        set {
            routeIdLabel.text = newValue
        }

        get {
            return routeIdLabel.text ?? ""
        }
    }

    public var time: Double {
        set {
            timeLabel.text = setTimeText(forMinutes: newValue)
        }

        get {
            return 0
        }
    }

    @IBOutlet private weak var routeIdLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        routeIdLabel.text = ""
        timeLabel.text = ""
        timeLabel.textColor = .black
    }

    private func setTimeText(forMinutes minutes: Double) -> String {
        let mins = Int(minutes)

        var text = "\(mins) minutos"

        if mins <= 5 {
            timeLabel.textColor = busInStopColor
        }
        else if mins < 10 {
            timeLabel.textColor = nearBusColor
        }

        if mins == 0 {
            text = "PRÓXIMO"
        }
        else if mins > 60 {
            text = "60+ minutos"
        }

        return text
    }

}
