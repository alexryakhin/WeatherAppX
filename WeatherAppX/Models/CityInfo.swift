//
//  CityInfo.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/13/22.
//
//  Model that I parse fetched data into, and then save it to the CoreData

import Foundation

struct CityInfo {
    var id: Int
    var name: String
    var temperature: Double
    var timeZone: Int
    var feelsLike: Double
    var tempMin: Double
    var tempMax: Double
}
