//
//  InfoView.swift
//  WeatherAppX
//
//  Created by Alexander Ryakhin on 1/12/22.
//

import SwiftUI

struct InfoView: View {
    @Binding var isCelcius: Bool
    var city: City
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(city.name ?? "")
                .font(.largeTitle)
            HStack {
                Text(temperature)
                    .font(.title2)
                Spacer()
                customToggle
            }
        }
        .padding(.vertical)
    }
    
    var customToggle: some View {
        HStack {
            Text("F").font(.title2)
            Toggle("Is Celcius", isOn: $isCelcius).labelsHidden()
            Text("C").font(.title2)
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
}
