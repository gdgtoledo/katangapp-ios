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
    
    var stop: BusStop?
    
    var starButton: UIBarButtonItem?
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        starButton = UIBarButtonItem(image: UIImage(named: "unfavourited"), style: .plain, target: self, action: #selector(BusStopDetailViewController.favouriteStop))
        self.navigationItem.rightBarButtonItem = starButton
        
        loadAnnotation()
    }
    
    func favouriteStop() {
        starButton?.image = UIImage(named: "favourited")
    }
    
    private func loadAnnotation() {
        guard let stop = stop else {
            return
        }
        
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
