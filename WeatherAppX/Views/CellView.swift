//
//  CellView.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/12/22.
//

import SwiftUI

struct CellView: View {
    var city: City
    @Binding var isCelcius: Bool
    var buttonAction: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(name + ", " + temperature)
                Text("\(date.formatted())")
            }
            Spacer()
            Button {
                buttonAction()
            } label: {
                Image(systemName: "doc.text.magnifyingglass")
            }
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
    
    var name: String {
        if let name = city.name {
            return name
        } else {
            return "City's name"
        }
    }
    
    var date: Date {
        if let date = city.timestamp {
            return date
        } else {
            return Date()
        }
    }
}
