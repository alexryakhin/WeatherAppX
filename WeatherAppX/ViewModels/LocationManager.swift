//
//  LocationManager.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/14/22.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
        switch manager.authorizationStatus {
        case .notDetermined, .restricted:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func requestLocation() throws {
        if manager.authorizationStatus == .denied {
            throw WeatherError.noLocationAccess("Allow to use your location in the settings of your device")
        } else {
            manager.startUpdatingLocation()
            location = manager.location?.coordinate
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
}

