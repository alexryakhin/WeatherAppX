//
//  CityID.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/13/22.
//
//  Model that I use to search through all cities locally

import Foundation

// MARK: - CityID
struct CityID: Codable, Identifiable {
    let id: Int
    let name: String
    let state: String
    let country: String
}
