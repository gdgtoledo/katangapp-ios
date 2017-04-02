//
//  BusStopDetailViewController.swift
//  Katanga
//
//  Created by Víctor Galán on 11/2/17.
//  Copyright © 2017 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit
import MapKit

class BusStopDetailViewController: UIViewController {
	
	let favouriteImage = UIImage(named: "favourited")
	let unfavouriteImage = UIImage(named: "unfavourited")
	
	var viewModel: BusStopDetailViewModel?
	var isFavourite = false
    
    var starButton: UIBarButtonItem?
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
		guard let viewModel = viewModel else { return }
		
		isFavourite = viewModel.isFavourite()
		
		let image = isFavourite ? favouriteImage : unfavouriteImage
        starButton = UIBarButtonItem(image: image, style: .plain, target: self,
			action: #selector(BusStopDetailViewController.favouriteStop))
        self.navigationItem.rightBarButtonItem = starButton
        
        loadAnnotation()
    }
    
    func favouriteStop() {
		if isFavourite {
			starButton?.image = unfavouriteImage
			viewModel?.unfavourite()
		}
		else {
			starButton?.image = favouriteImage
			viewModel?.favourite()
		}
		
		isFavourite = !isFavourite
    }
    
    private func loadAnnotation() {
		guard let stop = viewModel?.busStop else { return }
        title = stop.address
        
        let coordinates
            = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = stop.address
        
        self.mapView.addAnnotation(annotation)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
}
