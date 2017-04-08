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
import CoreLocation
import NSObject_Rx

class InitialViewController: UIViewController {

    @IBOutlet weak var metersLabel: UILabel!
    @IBOutlet weak var metersSlider: UISlider!

    @IBOutlet weak var searchLocationButton: UIButton! {
        didSet {
            searchLocationButton.backgroundColor = .katangaYellow
            searchLocationButton.layer.cornerRadius = 30

            spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            spinner!.color = .black
            spinner!.center = CGPoint(x: 30, y: 30)

            searchLocationButton.addSubview(spinner!)
        }
    }

    private var spinner: UIActivityIndicatorView?

	private var locationService = GeolocationService.instance

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setUpRx()

	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		rx_disposeBag = DisposeBag()
	}

    private func setUpRx() {
        metersSlider.rx.value
            .startWith(500)
            .map {"\(Int($0))"}
            .bindTo(metersLabel.rx.text)
            .addDisposableTo(rx_disposeBag)

        searchLocationButton.rx.tap
			.asObservable()
			.do(onNext: { [weak self] _ in
				self?.spinner?.startAnimating()
			})
			.flatMap { [unowned self] _ -> Driver<Bool> in
				self.locationService.authorized
			}
			.flatMap { [unowned self] authorized -> Driver<CLLocationCoordinate2D> in
				if authorized {
					return self.locationService.location
				}
				else {
					throw GeoLocationServiceError.unauthorized
				}
			}
			.take(1)
			.debug("location")
			.subscribe(onNext: { [unowned self] location in
				self.spinner?.stopAnimating()
				self.performSegue(withIdentifier: "shownearstops", sender: location)
			}, onError: { [unowned self] error in
				self.spinner?.stopAnimating()
				self.showUnauthorizedAlert()
			})
			.disposed(by: rx_disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let location = sender as! CLLocationCoordinate2D
//		let viewModel = NearBusStopCoordinatesViewModel(latitude: location.latitude, longitude: location.longitude, meters: Int(metersSlider.value))
		let viewModel = NearBusStopCoordinatesViewModel(latitude: 39.861293, longitude: -4.026146, meters: 1000)
        let vc = segue.destination as? NearBusStopsViewController
		vc?.hidesBottomBarWhenPushed = true
        vc?.viewModel = viewModel
    }

	private func showUnauthorizedAlert() {
		let alert = UIAlertController(title: "Error",
		message: "La localización está desactivada, esta aplicación necesita la ubicación para funcionar correctamente", preferredStyle: .alert)

		let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
		let openPreferences = UIAlertAction(title: "Activar ubicación", style: .default) {[weak self] _ in
			self?.rx_disposeBag = DisposeBag()
			self?.setUpRx()
			UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
		}

		alert.addAction(cancel)
		alert.addAction(openPreferences)

		self.present(alert, animated: true, completion: nil)
	}

}
