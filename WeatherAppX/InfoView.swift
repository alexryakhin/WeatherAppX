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
            Text(city.name)
                .font(.largeTitle)
            HStack {
                Text("\(temperature)º")
                    .font(.title2)
                Spacer()
                customToggle
            }
        }
    }
    
    var customToggle: some View {
        HStack {
            Text("F").font(.title2)
            Toggle("Is Celcius", isOn: $isCelcius).labelsHidden()
            Text("C").font(.title2)
        }
    }
    
    var temperature: Int {
        if isCelcius {
            return 28
        } else {
            return 82
        }
//        Int(city.temperature)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(isCelcius: .constant(false), city: City.mockCityStuttgard)
    }
}
