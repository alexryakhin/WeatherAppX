//
//  WeatherService.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/13/22.
//

import SwiftUI
import CoreLocation

actor WeatherService {
    
    static let apiKey = "d5552e3d5a1de5d3a7449ddd67e623f6"
    
    func getData(for cityID: Int) async throws -> CityInfo {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?id=\(cityID)&appid=\(WeatherService.apiKey)") else {
            throw URLError(.badURL)
        }
        let data = try await fetch(CityDTO.self, from: url)
        return CityInfo(id: data.id, name: data.name, temperature: data.main.temp, timeZone: data.timezone, feelsLike: data.main.feels_like, tempMin: data.main.temp_min, tempMax: data.main.temp_max)
    }
    
    func getData(for location: CLLocationCoordinate2D) async throws -> CityInfo {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(WeatherService.apiKey)") else {
            throw URLError(.badURL)
        }
        let data = try await fetch(CityDTO.self, from: url)
        return CityInfo(id: data.id, name: data.name, temperature: data.main.temp, timeZone: data.timezone, feelsLike: data.main.feels_like, tempMin: data.main.temp_min, tempMax: data.main.temp_max)
    }
}
