//
//  TableViewController.swift
//  RestaurantFinder
//
//  Created by Uldis Zingis on 16/11/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class TableViewController: UITableViewController, CLLocationManagerDelegate {

    let locManager = LocationController.sharedInstance.locationManager
    var restaurants: [Restaurant] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("Enable Location in Settings")
            case .authorizedAlways, .authorizedWhenInUse:
                locManager.desiredAccuracy = kCLLocationAccuracyBest
                locManager.activityType = .automotiveNavigation
                searchNearbyRestaurants()
            }
        } else {
            NSLog("Location services unavailable.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: { (placemark, error) in
            guard let placemark = placemark?.last, let title = placemark.postalCode else { return }
            DispatchQueue.main.async {
                self.title = "\(title)"
            }
        })
    }

    func searchNearbyRestaurants() {
        locManager.startUpdatingLocation()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Restaurants"
        let search = MKLocalSearch.init(request: request)
        self.restaurants = []

        search.start { (response, error) in
            guard let response = response else {
                print("Search error: \(error)")
                return
            }

            for item in response.mapItems {
                guard let name = item.name else { return }
                let restaurant = Restaurant(name: name, placemark: item.placemark)
                self.restaurants.append(restaurant)
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.locManager.stopUpdatingLocation()
            }
        }
    }

    @IBAction func refrechTapped(_ sender: Any) {
        searchNearbyRestaurants()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)

        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.name
        cell.detailTextLabel?.text = ""

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap" {
            guard let nextVC = segue.destination as? MapViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            nextVC.restaurant = restaurants[indexPath.row]
        }
    }
}
