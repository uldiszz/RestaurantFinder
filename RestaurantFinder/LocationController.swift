//
//  LocationController.swift
//  RestaurantFinder
//
//  Created by Uldis Zingis on 16/11/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController {
    
    static let sharedInstance = LocationController()
    
    var locationManager: CLLocationManager
    
    init() {
        self.locationManager = CLLocationManager()
    }
}
