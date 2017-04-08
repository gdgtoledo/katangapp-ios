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
	
	let favoriteImage = UIImage(named: "favorited")
	let unfavoriteImage = UIImage(named: "unfavorited")
	
	var viewModel: BusStopDetailViewModel?
	var isFavorite = false
    
    var starButton: UIBarButtonItem?
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
		guard let viewModel = viewModel else { return }
		
		isFavorite = viewModel.isFavorite()
		
		let image = isFavorite ? favoriteImage : unfavoriteImage
        starButton = UIBarButtonItem(image: image, style: .plain, target: self,
			action: #selector(BusStopDetailViewController.favoriteStop))
        self.navigationItem.rightBarButtonItem = starButton
        
        loadAnnotation()
    }
    
    func favoriteStop() {
		if isFavorite {
			starButton?.image = unfavoriteImage
			viewModel?.unfavorite()
		}
		else {
			starButton?.image = favoriteImage
			viewModel?.favorite()
		}
		
		isFavorite = !isFavorite
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
