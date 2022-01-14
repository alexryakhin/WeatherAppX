//
//  CityDTO.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/13/22.
//
import Foundation

// MARK: - CityDTO
struct CityDTO: Codable {
    let main: Main
    let timezone: Int
    let name: String
    let id: Int
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
}
