//
//  Restaurant.swift
//  RestaurantFinder
//
//  Created by Uldis Zingis on 16/11/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import Foundation
import MapKit

class Restaurant {
    let name: String
    let placemark: MKPlacemark

    init(name: String, placemark: MKPlacemark) {
        self.name = name
        self.placemark = placemark
    }
}
