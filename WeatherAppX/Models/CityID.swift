//
//  CityID.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/13/22.
//

import Foundation

// MARK: - CityID
struct CityID: Codable, Identifiable {
    let id: Int
    let name: String
    let state: String
    let country: String
}
