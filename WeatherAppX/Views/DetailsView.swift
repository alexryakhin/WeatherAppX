//
//  DetailsView.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/14/22.
//

import SwiftUI

struct DetailsView: View {
    var city: City
    @Binding var isCelcius: Bool
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text(temperature)
                } header: {
                    Text("actual temperature")
                }
                
                Section {
                    Text(feelsLike)
                } header: {
                    Text("what it Feels like")
                }
                
                Section {
                    Text("Minimum of " + tempMin)
                    Text("Maximum of " + tempMax)
                } header: {
                    Text("temperature throughout the day")
                }
            }
            .navigationTitle(city.name ?? "City")
        }
    }
    
    var temperature: String {
        if isCelcius {
            let converted = Int(city.temperature.convertTemperature(from: .kelvin, to: .celsius))
            return "\(converted)ºC"
        } else {
            let converted = Int(city.temperature.convertTemperature(from: .kelvin, to: .fahrenheit))
            return "\(converted)ºF"
        }
    }
    
    var feelsLike: String {
        if isCelcius {
            let converted = Int(city.feelsLike.convertTemperature(from: .kelvin, to: .celsius))
            return "\(converted)ºC"
        } else {
            let converted = Int(city.feelsLike.convertTemperature(from: .kelvin, to: .fahrenheit))
            return "\(converted)ºF"
        }
    }
    
    var tempMin: String {
        if isCelcius {
            let converted = Int(city.tempMin.convertTemperature(from: .kelvin, to: .celsius))
            return "\(converted)ºC"
        } else {
            let converted = Int(city.tempMin.convertTemperature(from: .kelvin, to: .fahrenheit))
            return "\(converted)ºF"
        }
    }
    
    var tempMax: String {
        if isCelcius {
            let converted = Int(city.tempMax.convertTemperature(from: .kelvin, to: .celsius))
            return "\(converted)ºC"
        } else {
            let converted = Int(city.tempMax.convertTemperature(from: .kelvin, to: .fahrenheit))
            return "\(converted)ºF"
        }
    }
}
