//
//  MapViewController.swift
//  RestaurantFinder
//
//  Created by Uldis Zingis on 16/11/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var restaurant: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    func setUp() {
        guard let restaurant = self.restaurant else { return }
        self.title = "\(restaurant.name)"
        centerMapOnLocation(coordinate: restaurant.placemark.coordinate)
        let annotation = MKPointAnnotation()
        annotation.coordinate = restaurant.placemark.coordinate
        mapView.addAnnotation(annotation)
    }

    func centerMapOnLocation(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
        mapView.setRegion(region, animated: true)
    }
}
