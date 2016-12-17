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
import MapKit
import RxSwift
import RxCocoa

class MapViewController: UIViewController {

	public var viewModel: RouteDetailViewModel?

	@IBOutlet private weak var mapView: MKMapView!

	private var disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()

		addAnnotations()
	}

	private func addAnnotations() {
		viewModel?.getBusStops()
				.asObservable()
				.flatMap { Observable.from($0) }
				.map { stop -> MKPointAnnotation in
					let coordinates
							= CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)

					let annotation = MKPointAnnotation()
					annotation.coordinate = coordinates
					annotation.title = stop.address

					return annotation
				}
				.toArray()
				.subscribe(onNext: { [weak self] in
					self?.mapView.addAnnotations($0)
					self?.mapView.showAnnotations(self!.mapView.annotations, animated: true)
				})
				.addDisposableTo(disposeBag)
	}

}
