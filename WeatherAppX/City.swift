//
//  City.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/12/22.
//

import SwiftUI
import CoreLocation

struct City {
    var name: String
    var location: CLLocationCoordinate2D
    var temperature: Double
    
    static var mockCityStuttgard = City(name: "Stuttgard", location: CLLocationCoordinate2D(latitude: 48.7758, longitude: 9.1829), temperature: 300)
}
