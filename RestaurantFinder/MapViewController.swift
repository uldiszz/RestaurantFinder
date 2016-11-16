//
//  MapViewController.swift
//  RestaurantFinder
//
//  Created by Uldis Zingis on 16/11/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var restaurant: Restaurant?
    var currentPlacemark: CLPlacemark?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setUp()
    }

    func setUp() {
        guard let restaurant = self.restaurant else { return }
        self.title = "\(restaurant.name)"
        centerMapOnLocation(coordinate: restaurant.placemark.coordinate)

        let annotation = MKPointAnnotation()
        annotation.coordinate = restaurant.placemark.coordinate
        mapView.addAnnotation(annotation)

        showDirectionsFor()
    }

    func centerMapOnLocation(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
        mapView.setRegion(region, animated: true)
    }

    func showDirectionsFor() {
        guard let restaurant = self.restaurant,
             let currentPlacemark = self.currentPlacemark,
             let currentCoordinate = currentPlacemark.location?.coordinate else { return }
        let request = MKDirectionsRequest()

        let currentMKPlacemark = MKPlacemark(coordinate: currentCoordinate, addressDictionary: currentPlacemark.addressDictionary as! [String : Any]?)
        request.source = MKMapItem(placemark: currentMKPlacemark)
        request.destination = MKMapItem(placemark: restaurant.placemark)
        request.transportType = .walking

        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let response = response else { return }
            if error != nil {
                for route in response.routes {
                    let route = route as MKRoute
                    self.mapView.add(route.polyline, level: .aboveRoads)
                }
            } else {
                NSLog("Error calculating directions: \(error)")
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKPolyline.classForCoder()) {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKOverlayRenderer()
    }
}


